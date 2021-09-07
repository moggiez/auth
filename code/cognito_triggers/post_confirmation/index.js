const AWS = require("aws-sdk");
const db = require("@moggiez/moggies-db");
const uuid = require("uuid");

const TABLE_CONFIG = {
  tableName: "organisations",
  hashKey: "OrganisationId",
  sortKey: "UserId",
  indexes: {
    UserOrganisations: {
      hashKey: "UserId",
      sortKey: "OrganisationId",
    },
  },
};
const organisations = new db.Table({ config: TABLE_CONFIG, AWS });

exports.handler = async (event, context, callback) => {
  const userName = event.userName;
  if (
    event.request.userAttributes.hasOwnProperty("custom:orgInviteBy") &&
    event.request.userAttributes.hasOwnProperty("custom:organisationId")
  ) {
    const invitedBy = event.request.userAttributes["custom:orgInviteBy"];
    const orgId = event.request.userAttributes["custom:organisationId"];
    const ownerOrg = await organisations.get({
      hashKey: orgId,
      sortKey: invitedBy,
    });
    const attributes = {
      InvitedBy: invitedBy,
      Name: ownerOrg.Item.Name,
      Owner: invitedBy,
    };
    await organisations.create({
      hashKey: orgId,
      sortKey: userName,
      record: attributes,
    });
  } else {
    const email = event.request.userAttributes.email;
    const attributes = {
      InvitedBy: "self",
      Name: email.split("@")[0],
      Owner: userName,
    };
    const orgId = uuid.v4();
    await organisations.create({
      hashKey: orgId,
      sortKey: userName,
      record: attributes,
    });
  }

  callback(null, event);
};

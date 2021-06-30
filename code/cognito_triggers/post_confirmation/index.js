const db = require("moggies-db");
const uuid = require("uuid");
const organisations = new db.Table(db.tableConfigs.organisations);

exports.handler = async (event, context, callback) => {
  const userName = event.userName;
  if (
    event.request.userAttributes.hasOwnProperty("custom:orgInviteBy") &&
    event.request.userAttributes.hasOwnProperty("custom:organisationId")
  ) {
    const invitedBy = event.request.userAttributes["custom:orgInviteBy"];
    const orgId = event.request.userAttributes["custom:organisationId"];
    const ownerOrg = await organisations.get(orgId, invitedBy);
    const attributes = {
      InvitedBy: invitedBy,
      Name: ownerOrg.Item.Name,
      Owner: invitedBy,
    };
    await organisations.create(orgId, userName, attributes);
  } else {
    const email = event.request.userAttributes.email;
    const attributes = {
      InvitedBy: "self",
      Name: email.split("@")[0],
      Owner: userName,
    };
    const orgId = uuid.v4();
    await organisations.create(orgId, userName, attributes);
  }

  callback(null, event);
};

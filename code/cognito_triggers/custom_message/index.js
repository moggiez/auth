exports.handler = (event, context, callback) => {
  if (event.triggerSource === "CustomMessage_SignUp") {
    const confirmUrl = `https://www.moggies.io/auth/confirm?clientId=${event.callerContext.clientId}&user_name=${event.request.userAttributes.sub}&confirmation_code=${event.request.codeParameter}`;
    const message = `Please click the link below to verify your email address. <a href=${confirmUrl}>Verify Email</a>`;
    event.response.smsMessage =
      "Welcome to the service. Your confirmation code is " +
      event.request.codeParameter;
    event.response.emailSubject =
      "Welcome to moggies.io! Please confirm your account!";
    event.response.emailMessage = message;
  } else if (event.triggerSource === "CustomMessage_ForgotPassword") {
    const resetUrl = `https://www.moggies.io/auth/changepass?user_name=${event.request.userAttributes.sub}&confirmation_code=${event.request.codeParameter}`;
    const message = `Please click the link below to reset your password. <a href=${resetUrl}>Reset Rassword</a>`;
    event.response.smsMessage =
      "Forgotten password on moggies.io - reset password code: " +
      event.request.codeParameter;
    event.response.emailSubject =
      "Forgotten password on moggies.io - reset password.";
    event.response.emailMessage = message;
  }
  callback(null, event);
};

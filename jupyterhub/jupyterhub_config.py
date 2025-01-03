c.Authenticator.allow_all = True
c.Authenticator.admin_users = {'anna'}
# c.LocalAuthenticator.create_system_users=True
c.Authenticator.delete_invalid_users = True
c.DummyAuthenticator.password = 'anna'
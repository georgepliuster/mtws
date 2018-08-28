require 'houston'

# Environment variables are automatically read, or can be overridden by any specified options. You can also
# conveniently use `Houston::Client.development` or `Houston::Client.production`.
APN = Houston::Client.development
APN.certificate = File.read('/Users/george.liu/Desktop/pushCert.pem')

# An example of the token sent back when a device registers for notifications
token = '<a3065d51e9272ac86e99e1ba995f0e54504c1e5bbfeaa83a1c36e97085908a00>'

# Create a notification that alerts a message to the user, plays a sound, and sets the badge on the app
notification = Houston::Notification.new(device: token)
notification.alert = 'Hello, World!'

# Notifications can also change the badge count, have a custom sound, have a category identifier, indicate available Newsstand content, or pass along arbitrary data.
notification.badge = 57
notification.sound = 'sosumi.aiff'
notification.category = 'INVITE_CATEGORY'
notification.content_available = true
notification.mutable_content = true
notification.custom_data = { foo: 'bar' }

# And... sent! That's all it takes.
APN.push(notification)
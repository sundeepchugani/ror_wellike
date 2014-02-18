# `certificate` is the only required option; the rest will default to the values
# shown here.
#
# Information on obtaining a `.pem` file for use with `certificate` is shown
# later.
pusher = Grocer.pusher(
  :certificate => "/path/to/apple_push_notification.pem",      # required
  :passphrase =>  "123",                       # optional
  :gateway =>     "gateway.push.apple.com", # optional; See note below.
  :port =>        2195,                     # optional
  :retries =>     3                         # optional
)
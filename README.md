# pingdom-ips
To be used in conjunction with HTTP_AUTH for Nginx when you want to allow access to Pingdom monitoring service
enabled and you need to whitelist Pingdom service IPs in the http_auth.

* Install the allow_from_pingdom_ips.conf file for NGINX
* Installs a BASH script to fetch the update IPs from pingdom and install them
into a allow_from_pingdom_ips.conf
* Installs a cronjob that periodically runs the BASH script

## Requirements

IPv6 addresses are supported starting from versions 1.3.0 and 1.2.1 (Nginx version)

Need to update the NGINX site file with:
```
   satisfy any;
   ...
   include allow_from_pingdom_ips.conf;
   ...
   deny all;
```

or the nginx site erb template as follow
```
    satisfy any;
    ...
<% (@params['allow_from_lists'] || []).each do |file| %>
    include <%= file %>;
<% end %>
    ...
    deny all;
```

Need to add a `allow_from_lists` attribute for the allow_from file to be included

i.e.:
```
"nginx": {
  "sites": {
    "<site_name>": {
      "inherits": "my-app",
  ...
      "allow_from_lists":[ "allow_from_pingdom_ips.conf" ],
  ...
```


## Example of use
```
   "run_list": [
     ...
     "recipe[pingdom-ips::nginx-allow-from]"
  ]
```

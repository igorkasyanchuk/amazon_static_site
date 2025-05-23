# Static Site using Amazon S3 + Cloudflare + HTTPS

[![RailsJazz](https://github.com/igorkasyanchuk/rails_time_travel/blob/main/docs/my_other.svg?raw=true)](https://www.railsjazz.com)
[![https://www.patreon.com/igorkasyanchuk](https://github.com/igorkasyanchuk/rails_time_travel/blob/main/docs/patron.svg?raw=true)](https://www.patreon.com/igorkasyanchuk)

[!["Buy Me A Coffee"](https://github.com/igorkasyanchuk/get-smart/blob/main/docs/snapshot-bmc-button-small.png?raw=true)](https://buymeacoffee.com/igorkasyanchuk)


Upload static HTML/CSS/JS to the Amazon S3 and host HTTPS website for free using Cloudflare.

This tool allows you to upload a folder with your files to S3, configure for you Cloudflare account and map it all together so you will get a site with HTTPS.

This gem was used to deploy my site to production. So it's ready for everyday use.

## DEMO

![demo upload file to s3](/docs/amazon_static_site.gif)

## Installation

1. Install gem:

```
  $ gem install amazon_static_site
```  
    
  And run 

```
  amazon_static_site generate site123
  cd site123
```
  
  Edit `config.yml`.
    
2. You need to have account on Amazon, you need to get API `access_key_id` and `secret_access_key` from Amazon: https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html

3. You need to have an account on https://www.cloudflare.com/, and copy API-key from settings: https://support.cloudflare.com/hc/en-us/articles/200167836-Managing-API-Tokens-and-Keys

4. You need to configure settings file, where you need to put your Amazon S3 keys, Cloudflare keys, and settings for a domain.

5. Run this CLI `amazon_static_site deploy <path-to-config> <path-to-public-folder>`

6. Check the previous logs, you will see settings for nameservers which you need to put (one time) on your hosting provider (where you host your domain), and wait few minutes/hours until DNS will be updated.

7. You could make a changes to the HTML/CSS/JS and re-upload files. This time, you don't need to change nameservers.

## Usage

`amazon_static_site deploy ./template/config.yml ./template/public`

You can use generator `amazon_static_site generate <app>`.

## Local development

`amazon_static_site serve ./template/public`

## Options

```
domain:
  primary: "www.railsjazz.com"
  secondary: "railsjazz.com"
s3:
  region: us-west-1
  access_key_id: "XXXXXXXXXXXXXXXXXXXXXXX"
  secret_access_key: "YYYYYYYYYYYYYYYYYYYYYYYYYYYY"
cloudflare:
  email: my@email.com
  api_key: xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

## React app

For example you can create React app using `create-react-app`, do some coding, after this run `yarn build` and then copy files from `build/*` to the `public` folder to the generated amazon_static_site path. Or specify this `build` folder as public folder option.

`amazon_static_site deploy ./config.yml /path/to/react-app/build`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## TODO

- Check "non-www" domains
- Tests
- Better documentation

## Contributing

You are welcome to contribute.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[<img src="https://github.com/igorkasyanchuk/rails_time_travel/blob/main/docs/more_gems.png?raw=true"
/>](https://www.railsjazz.com/?utm_source=github&utm_medium=bottom&utm_campaign=amazon_static_site)

[!["Buy Me A Coffee"](https://github.com/igorkasyanchuk/get-smart/blob/main/docs/snapshot-bmc-button.png?raw=true)](https://buymeacoffee.com/igorkasyanchuk)

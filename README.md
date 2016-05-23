# AirApi

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

# Deploy AirBudget

* Compile the app and the assets:
```
MIX_ENV=prod mix compile
brunch build --production
MIX_ENV=prod mix phoenix.digest
```
* Generate a release with **exrm**

* In the deployment server execute the following Elixir Module to create and migrate the database
```
DATABASE_USERNAME=<YOURUSERNAME> DATABASE_PASSWORD=<YOURPASSWORD> RELX_REPLACE_OS_VARS= true rel/air_api/bin/air_api command Elixir.AirApi.ReleaseTasks create
DATABASE_USERNAME=<YOURUSERNAME> DATABASE_PASSWORD=<YOURPASSWORD> RELX_REPLACE_OS_VARS= true rel/air_api/bin/air_api command Elixir.AirApi.ReleaseTasks migrate
```

Don't forget to run the rel app with **RELX_REPLACE**
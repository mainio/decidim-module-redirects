# Decidim::Redirects

[![Build Status](https://github.com/mainio/decidim-module-redirects/actions/workflows/ci_redirects.yml/badge.svg)](https://github.com/mainio/decidim-module-redirects/actions)
[![codecov](https://codecov.io/gh/mainio/decidim-module-redirects/branch/master/graph/badge.svg)](https://codecov.io/gh/mainio/decidim-module-redirects)

A [Decidim](https://github.com/decidim/decidim) module to add possibility to
add redirections to the system. When things are moved or changed in the system,
it is many times needed to redirect old URLs to new ones.

The gem has been developed by [Mainio Tech](https://www.mainiotech.fi/).

The development has been sponsored by the
[City of Helsinki](https://www.hel.fi/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-redirects"
```

And then execute:

```bash
$ bundle
$ bundle exec rails decidim_redirects:install:migrations
$ bundle exec rails db:migrate
```

To keep the gem up to date, you can use the commands above to also update it.

## Usage

1. Sign in as admin
2. Go to admin dashboard
3. Click Redirects from main nav
4. Fill form
  - a. Priority (defines order in index view(*))
  - b. Path (path where redirect activates)
  - c. Parameters (optional path parameters)
  - d. External (if target is outside of the current organization)
  - e. Target (where redirect redirects)
5. Submit
6. Navigate to the path you set in 4b.
7. You should be redirected to the target you set in 4e.

(*) /admin/redirects/redirections

## Contributing

See [Decidim](https://github.com/decidim/decidim).

### Developing

To start contributing to this project, first:

- Install the basic dependencies (such as Ruby and PostgreSQL)
- Clone this repository

Decidim's main repository also provides a Docker configuration file if you
prefer to use Docker instead of installing the dependencies locally on your
machine.

You can create the development app by running the following commands after
cloning this project:

```bash
$ bundle
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake development_app
$ npm i
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

Then to test how the module works in Decidim, start the development server:

```bash
$ cd development_app
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rails s
```

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add the environment variables to the root directory of the project in a file
named `.rbenv-vars`. If these are defined for the environment, you can omit
defining these in the commands shown above.

#### Code Styling

Please follow the code styling defined by the different linters that ensure we
are all talking with the same language collaborating on the same project. This
project is set to follow the same rules that Decidim itself follows.

The following linters are used:

- Ruby, [Rubocop](https://rubocop.readthedocs.io/)
- JS/ES, [eslint](https://eslint.org/)

You can run the code styling checks by running the following commands from the
console:

```
$ bundle exec rubocop
$ npm run lint
```

To ease up following the style guide, you should install the plugins to your
favorite editor, such as:

- Atom
  * [linter-rubocop](https://atom.io/packages/linter-rubocop)
  * [linter-eslint](https://atom.io/packages/linter-eslint)
- Sublime Text
  * [Sublime RuboCop](https://github.com/pderichs/sublime_rubocop)
  * [SublimeLinter-eslint](https://github.com/SublimeLinter/SublimeLinter-eslint)
- Visual Studio Code
  * [Rubocop for Visual Studio Code](https://github.com/misogi/vscode-ruby-rubocop)
  * [VS Code ESLint extension](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)

### Testing

To run the tests run the following in the gem development path:

```bash
$ bundle
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake test_app
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rspec
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add these environment variables to the root directory of the project in a
file named `.rbenv-vars`. In this case, you can omit defining these in the
commands shown above.

### Test code coverage

If you want to generate the code coverage report for the tests, you can use
the `SIMPLECOV=1` environment variable in the rspec command as follows:

```bash
$ SIMPLECOV=1 bundle exec rspec
```

This will generate a folder named `coverage` in the project root which contains
the code coverage report.

## License

See [LICENSE-AGPLv3.txt](LICENSE-AGPLv3.txt).

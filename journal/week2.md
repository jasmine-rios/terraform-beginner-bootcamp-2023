# Terraform Beginner Bootcamp 2023 - Week2

## Working with Ruby

### Bundler

A package manager for Ruby. It is the primary way to install ruby packages, known as gems for ruby.

#### Installing Gems

You need to create a gemfile and define your gems in that file.

```Gemfile
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'

```
Then you need to run the `bundle install` command.

This will install the gems on the system globally (unlike NodeJS that installs packages in place in a folder called node_modules)

A gemfile.lock will be created to lock down gem versions being used in this project

#### Executing Ruby Scripts in the Content of Bundler

We have to use `bundle exec` to tell future ruby scripts to use the gems we installed. This is the way we set context.

### Sinatra 

Sinatra is a micro web framework for ruby to build web-apps. 

It is great for mock or development servers or very simple projects

You can create a web-server in a single file.

[Sinatra](https://sinatrarb.com)

## TerraTowns Mock Server

### Running the Web Server

We can run the web server by executing the follow commands:

```rb
bundle install
bundle exec ruby server.rb
```

All of the code for our websever is installed in our server.rb file

## CRUD

Terraform provider resources utilize CRUD.

CRUD stands for Create, Read, Update, and Delete

[CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete)

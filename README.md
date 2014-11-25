# Wolverine

## Development Setup

Install gems:

```bash
bundle
```

Setup DB with sample data:

```bash
rake db:bootstrap
```

Start server on port 3000:

```bash
rails server
```

## Deploy to Production

Setup heroku

```bash
git remote add heroku git@heroku.com:wolverinesc.git
git push heroku master
```

Deploy:

```bash
git push heroku
```

## Product Import

Run spider:

```bash
ruby script/spider.rb > products.csv
```

Import products:

```bash
rails runner script/import.rb
```

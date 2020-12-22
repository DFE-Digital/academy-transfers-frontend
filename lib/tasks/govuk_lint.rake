desc "Lint ruby code"
namespace :lint do
  desc "Ruby lint via rubocop"
  task ruby: :environment do
    puts "Linting ruby..."
    system "bundle exec rubocop app config db lib spec Gemfile --format clang -a"
  end

  desc "SCSS lint"
  task scss: :environment do
    puts "Linting scss..."
    system "bundle exec scss-lint app/webpacker/styles"
  end
end

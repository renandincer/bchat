FROM ruby:2.2.4-onbuild
ENV RACK_ENV production
CMD ["ruby", "app.rb"]


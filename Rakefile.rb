require 'rake'
require 'rspec/core/rake_task'

def is_git_dirty
  status = `git status --porcelain 2> /dev/null`.strip
  return "" != status
end

def snapshot
  if is_git_dirty
    return "-SNAPSHOT"
  else
    return ""
  end
end

SHORT_IMAGE_NAME = 'dwolla/jenkins-agent-core'
IMAGE_VERSION = `git rev-parse --short HEAD`.strip + snapshot
IMAGE_NAME = "#{SHORT_IMAGE_NAME}:#{IMAGE_VERSION}"

desc "Build the Docker Image"
task :build do
  sh "docker build --tag #{IMAGE_NAME} ."
end

desc 'Publish Docker image to dwolla.docker.net'
task :publish do
  sh "docker tag #{IMAGE_NAME} docker.dwolla.net/#{IMAGE_NAME}"
  sh "docker tag #{IMAGE_NAME} docker.dwolla.net/#{SHORT_IMAGE_NAME}:latest"
  sh "docker push docker.dwolla.net/#{SHORT_IMAGE_NAME}"
end

desc "Clean up artifacts and local Docker images"
task :clean do
  if images.length > 0
    sh "docker rmi -f #{images}"
  end
end

def images
  `docker images | fgrep #{SHORT_IMAGE_NAME} | awk '{if ($2 == #{IMAGE_VERSION}) print $3}' | awk ' !x[$0]++' | paste -sd ' ' -`
end

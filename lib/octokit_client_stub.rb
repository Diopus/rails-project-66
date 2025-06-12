# frozen_string_literal: true

class OctokitClientStub
  include Rails.application.routes.url_helpers

  Repo = Struct.new(:name, :id, :full_name, :language, :clone_url, :ssh_url, :parent, :owner, :fork, :default_branch) do
    def fork?
      !!fork
    end
  end

  # Stub for list of repos
  def repos
    [
      Repo.new(name: 'repo1', id: 1, language: 'ruby', fork: false),
      Repo.new(name: 'repo2', id: 2, language: 'javascript', fork: false),
      Repo.new(name: 'repo3', id: 3, language: 'python', fork: false),
      Repo.new(name: 'repo4', id: 4, language: nil, fork: true)
    ]
  end

  alias repositories repos

  Owner = Struct.new(:login)

  # Stub for repo info
  def repo(github_id)
    owner = Owner.new('user')
    parent = Repo.new(language: 'ruby')
    Repo.new(
      name: 'test',
      id: github_id,
      full_name: 'test/test',
      language: parent.language,
      clone_url: 'https://github.com/test/test.git',
      ssh_url: 'git@github.com:test/test.git',
      owner:,
      parent:,
      fork: true,
      default_branch: 'main'
    )
  end

  alias repository repo

  # Stub for commit info
  Commit = Struct.new(:sha)
  def commits(_, _)
    [Commit.new('79dedc238ec30bc5f7c5ee8005e66c99d42a97f6')]
  end

  def create_hook(_, _, _, _) # rubocop:disable Naming/PredicateMethod,Lint/RedundantCopDisableDirective
    true
  end

  def hooks(_)
    hook = Struct.new(:config).new(Struct.new(:url).new(api_checks_url))
    [hook]
  end
end

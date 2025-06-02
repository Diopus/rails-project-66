# frozen_string_literal: true

class OctokitClientStub
  Repo = Struct.new(:name, :id, :full_name, :language, :clone_url, :ssh_url, :parent, :owner, :fork, :default_branch)

  # Stub for list of repos
  def repos
    [
      Repo.new(name: 'repo1', id: 1, language: 'Ruby', fork: false),
      Repo.new(name: 'repo2', id: 2, language: 'JavaScript', fork: false),
      Repo.new(name: 'repo3', id: 3, language: 'Python', fork: false),
      Repo.new(name: 'repo4', id: 4, language: nil, fork: true)
    ]
  end

  alias repositories repos

  Owner = Struct.new(:login)
  @owner = Owner.new('user')

  @parent = Repo.new(language: 'Ruby')

  # Stub for repo info
  def repo(_)
    Repo.new(
      name: 'test',
      id: 4,
      full_name: 'test/test',
      language: nil,
      clone_url: 'https://github.com/test/test.git',
      ssh_url: 'git@github.com:test/test.git',
      parent: @parent,
      owner: @owner,
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

  def create_hook(_, _, _, _)
    true
  end
end

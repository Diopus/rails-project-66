# frozen_string_literal: true

class Open3Stub
  Response = Struct.new(:stdout, :stderr, :status)

  def initialize
    @responses = []
    add_default_responses
  end

  def add_default_responses
    add_response(/rm -rf/, stdout: '', exitstatus: 0)
    add_response(/git clone/, stdout: '', exitstatus: 0)
    add_response(/rubocop/, stdout: '{}', exitstatus: 0)
    add_response(/eslint/, stdout: '[]', exitstatus: 0)
  end

  # Regexp matcher
  def add_response(matcher, stdout:, stderr: '', exitstatus: 0)
    status = Struct.new(:exitstatus).new(exitstatus)
    @responses << [matcher, Response.new(stdout, stderr, status)]
  end

  def capture3(cmd)
    resp = find_response(cmd)
    [resp.stdout, resp.stderr, resp.status]
  end

  def capture2e(cmd)
    resp = find_response(cmd)
    [resp.stdout + resp.stderr, resp.status]
  end

  private

  def find_response(cmd)
    _, resp = @responses.reverse.find { |m, _| cmd.match?(m) }
    return resp if resp

    raise "Open3Stub: unexpected command: #{cmd.inspect}"
  end
end

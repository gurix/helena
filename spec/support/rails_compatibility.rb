# As in rails 5.1 we can no longer accept direct hashes as parameters so we ned to cast it
def parametrize(params)
  Rails.version.to_f >= 5 ? { params: params } : params
end
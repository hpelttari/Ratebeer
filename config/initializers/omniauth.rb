Rails.application.config.middleware.use OmniAuth::Builder do
    provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
    #provider :github, 'eb78ce1d134712953064', '09d323815f7a378264702cc7f7fc1537d7c1d69f'
   end
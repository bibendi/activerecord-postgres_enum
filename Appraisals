# frozen_string_literal: true

appraise '4.2' do
  gem 'pg', '~> 0.15'
  gem 'activerecord', '~> 4.2'
end

appraise '5.0' do
  gem 'activerecord', '~> 5.0'
end

appraise '5.1' do
  gem 'activerecord', '~> 5.1'
end

appraise '5.2' do
  gem 'activerecord', '~> 5.2'
end

appraise '6.0.0.beta1' do
  gem 'activerecord', '6.0.0.beta1'
  # ISSUE: https://github.com/pat/combustion/issues/96
  gem "combustion", github: "pat/combustion",
                    ref: "3c4bc97e0ff7870c1589bcdbc1c41b3966932eb6"
end

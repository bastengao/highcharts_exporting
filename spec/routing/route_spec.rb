require 'rails_helper'

describe 'routing' do
  it 'root', type: :routing do
    expect(post: '/highcharts/export').to route_to(controller: 'highcharts', action: 'export')
  end

end

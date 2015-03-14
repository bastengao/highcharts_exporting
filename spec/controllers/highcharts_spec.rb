require 'rails_helper'

describe HighchartsController do

  # example data:
  #   http://export.highcharts.com/demo
  let(:options) {
    <<-OPT
    {
      xAxis: {
        categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
      },
      series: [{
        data: [29.9, 71.5, 106.4, 129.2, 144.0, 176.0,
          135.6, 148.5, 216.4, 194.1, 95.6, 54.4]
      }]
    };
    OPT
  }

  let(:svg) {
    File.read('spec/chart.svg')
  }

  let(:callback) {
    <<-FUC
    function(chart) {
      chart.renderer.label('This label is added in the callback', 100, 100)
          .attr({
                    fill : '#90ed7d',
          padding: 10,
          r: 10,
          zIndex: 10
    })
    .css({
             color: 'black',
             width: '100px'
         })
         .add();
    }
    FUC
  }

  it 'export through options' do
    post :export, options: options, type: 'image/png', scale: 2, callback: callback, constr: 'Chart'
    expect(response).to be_success
    expect(response.content_type).to eq 'image/png'
  end

  it 'export through svg' do
    post :export, svg: svg, type: 'image/png', scale: 2, c1llback: callback
    expect(response).to be_success
    expect(response.content_type).to eq 'image/png'
  end

  it 'export specific filename' do
    post :export, options: options, type: 'image/png', filename: 'my_chart'
    expect(response).to be_success
    expect(response.content_type).to eq 'image/png'
    expect(response['Content-Disposition']).to include 'my_chart.png'
  end

  describe 'type' do
    it 'export to jpeg' do
      post :export, options: options, type: 'image/jpeg', scale: 2, c1llback: callback
      expect(response).to be_success
      expect(response.content_type).to eq 'image/jpeg'
    end

    it 'export to pdf' do
      post :export, options: options, type: 'application/pdf', scale: 2, c1llback: callback
      expect(response).to be_success
      expect(response.content_type).to eq 'application/pdf'
    end

    it 'export to svg' do
      post :export, options: options, type: 'image/svg+xml', scale: 2, c1llback: callback
      expect(response).to be_success
      expect(response.content_type).to eq 'image/svg+xml'
    end
  end

  describe 'default params' do
    it 'default scale' do
      post :export, options: options, type: 'image/png', callback: callback, constr: 'Chart'
      expect(response).to be_success
      expect(response.content_type).to eq 'image/png'
    end

    it 'default constr' do
      post :export, options: options, type: 'image/png', scale: 2, callback: callback
      expect(response).to be_success
      expect(response.content_type).to eq 'image/png'
    end

    it 'default type' do
      post :export, options: options, scale: 2, callback: callback, constr: 'Chart'
      expect(response).to be_success
      expect(response.content_type).to eq 'image/png'
    end

    it 'missing callback' do
      post :export, options: options, type: 'image/png', scale: 2, constr: 'Chart'
      expect(response).to be_success
      expect(response.content_type).to eq 'image/png'
    end
  end

end

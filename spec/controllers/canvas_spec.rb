require 'rails_helper'

describe CanvasController do

  # example data:
  #   http://export.highcharts.com/demo
  let(:options) {
    <<-OPT
    {\"backgroundColor\":\"#FFFFFF\",\"creditText\":null,\"colorSet\":\"fortissingle\",\"title\":{\"text\":\"DURATION OF GENERAL SURVIVAL PERIOD (2012-PRESENT)\",\"horizontalAlign\":\"left\",\"fontColor\":\"#676767\",\"fontFamily\":\"Noto Sans\",\"fontSize\":19},\"legend\":{\"fontSize\":14,\"verticalAlign\":\"bottom\",\"horizontalAlign\":\"center\",\"fontFamily\":\"Helvetica\",\"fontColor\":\"#808080\",\"fontWeight\":\"bold\"},\"toolTip\":{\"enabled\":false},\"data\":[{\"indexLabelFontSize\":14,\"indexLabelFontFamily\":\"Noto Sans\",\"indexLabelFontColor\":\"#b1b5ba\",\"indexLabelLineColor\":\"#b1b5ba\",\"indexLabelFontWeight\":\"700\",\"indexLabelPlacement\":\"outside\",\"type\":\"bar\",\"showInLegend\":false,\"dataPoints\":[{\"y\":0.02,\"name\":\"2%\",\"label\":\"\u2264 11 months\",\"original_label\":\"\u2264 11 months\",\"indexLabel\":\"2%\"},{\"y\":0.22,\"name\":\"22%\",\"label\":\"12 months\",\"original_label\":\"12 months\",\"indexLabel\":\"22%\"},{\"y\":0.19,\"name\":\"19%\",\"label\":\"13 to 17 months\",\"original_label\":\"13 to 17 months\",\"indexLabel\":\"19%\"},{\"y\":0.48,\"name\":\"48%\",\"label\":\"18 months\",\"original_label\":\"18 months\",\"indexLabel\":\"48%\"},{\"y\":0.01,\"name\":\"1%\",\"label\":\"19 to 23 months\",\"original_label\":\"19 to 23 months\",\"indexLabel\":\"1%\"},{\"y\":0.07,\"name\":\"7%\",\"label\":\"24 months\",\"original_label\":\"24 months\",\"indexLabel\":\"7%\"},{\"y\":0.01,\"name\":\"1%\",\"label\":\"\u2265 25 months\",\"original_label\":\"\u2265 25 months\",\"indexLabel\":\"1%\"}]}],\"has_data\":true,\"definitions\":[{\"definition\":\"<p><strong>Sample General Survival Period:</strong><em> &ldquo;All representations and warranties, covenants and other indemnification obligations contained in this Agreement or in any certificate delivered pursuant thereto <span style=\\\"text-decoration: underline;\\\">shall terminate on the date that is eighteen months after the Closing Date</span>.&rdquo;</em></p>\"}],\"axisY\":{\"minimum\":0,\"labelFontFamily\":\"Noto Sans\",\"gridThickness\":0,\"valueFormatString\":\" \",\"gridColor\":\"#FFFFFF\",\"titleFontColor\":\"#FFFFFF\",\"labelFontColor\":\"#FFFFFF\",\"lineThickness\":0,\"tickThickness\":0,\"maximum\":0.8},\"axisX\":{\"interval\":1,\"labelFontFamily\":\"Noto Sans\",\"gridThickness\":0,\"labelFontSize\":14},\"seed_number\":334}
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

  it 'export through options to specific path' do
    post :export, options: options, type: 'image/png', scale: 2, callback: callback, constr: 'Chart', outputpath: './spec/dummy/tmp'
    expect(response).to be_success
    expect(response.content_type).to eq 'image/png'
  end

    it 'export through options to specific file' do
      post :export, options: options, type: 'image/png', scale: 2, callback: callback, constr: 'Chart', outputpath: './spec/dummy/tmp', filename: 'chart_test3.png'
      expect(response).to be_success
      expect(response.content_type).to eq 'image/png'
    end
  # it 'export through svg' do
  #   post :export, svg: svg, type: 'image/png', scale: 2, c1llback: callback
  #   expect(response).to be_success
  #   expect(response.content_type).to eq 'image/png'
  # end
  #
  # it 'export specific filename' do
  #   post :export, options: options, type: 'image/png', filename: 'my_chart'
  #   expect(response).to be_success
  #   expect(response.content_type).to eq 'image/png'
  #   expect(response['Content-Disposition']).to include 'my_chart.png'
  # end
  #
  # describe 'type' do
  #   it 'export to jpeg' do
  #     post :export, options: options, type: 'image/jpeg', scale: 2, c1llback: callback
  #     expect(response).to be_success
  #     expect(response.content_type).to eq 'image/jpeg'
  #   end
  #
  #   it 'export to pdf' do
  #     post :export, options: options, type: 'application/pdf', scale: 2, c1llback: callback
  #     expect(response).to be_success
  #     expect(response.content_type).to eq 'application/pdf'
  #   end
  #
  #   it 'export to svg' do
  #     post :export, options: options, type: 'image/svg+xml', scale: 2, c1llback: callback
  #     expect(response).to be_success
  #     expect(response.content_type).to eq 'image/svg+xml'
  #   end
  # end

  # describe 'default params' do
  #   it 'default scale' do
  #     post :export, options: options, type: 'image/png', callback: callback, constr: 'Chart'
  #     expect(response).to be_success
  #     expect(response.content_type).to eq 'image/png'
  #   end
  #
  #   it 'default constr' do
  #     post :export, options: options, type: 'image/png', scale: 2, callback: callback
  #     expect(response).to be_success
  #     expect(response.content_type).to eq 'image/png'
  #   end
  #
  #   it 'default type' do
  #     post :export, options: options, scale: 2, callback: callback, constr: 'Chart'
  #     expect(response).to be_success
  #     expect(response.content_type).to eq 'image/png'
  #   end
  #
  #   it 'missing callback' do
  #     post :export, options: options, type: 'image/png', scale: 2, constr: 'Chart'
  #     expect(response).to be_success
  #     expect(response.content_type).to eq 'image/png'
  #   end
  # end

end

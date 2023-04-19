class ApplicationController < ActionController::API
    # テスト用のAPIを追加
  def test
    # テスト用のJSON形式のオブジェクト
    test_json_obj = [
      { id: 1, title: "First Text", text: "最初のテキスト" },
      { id: 2, title: "Second Text", text: "2番目のテキスト" },
    ]

    # JSON形式で出力
    render json: test_json_obj
  end
end

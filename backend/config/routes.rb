Rails.application.routes.draw do
  # テスト用のルーティングを追加
  scope "api" do
    scope "v1" do
      get "/test", to: "application#test"
    end
  end
end

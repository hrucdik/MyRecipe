## MyRecipe
### 1.アプリケーションの概要
MyRecipeは自分だけのレシピを保存できるアプリです。</br>
レシピを保存できる他に、材料などを確認するためのメモ帳機能も備えています。</br>
料理やお買い物の際に使用できるアプリになっています。</br>
</br>
### 2.使用技術
開発ツール:Xcode</br>
開発言語：Swift</br>
UIフレームワーク：SwiftUI</br>
データ管理：CoreData</br>
</br>
### 3.機能一覧
- レシピ一覧画面（左図）
    - 保存したレシピを一覧で確認できる画面
        - 画面左上のゴミ箱はレシピを一括削除できます。
        - 画面右上の単語カードのようなマークはカテゴリー別にレシピを表示できます。
        - 上記と似たような機能ですが、検索欄ではタイトル名・カテゴリー名でレシピを検索・表示できます。
- レシピ詳細画面（右図）
    - 各レシピの材料や作り方を確認できる画面
        - タイトル横にレシピ追加画面で選択したカテゴリーを表示しています。
        - 左上の矢印は、レシピ一覧画面に戻るボタンです（見えずらくてすみません）
        - 右上のゴミ箱を押すと単体でレシピを削除できます（見えずらくてすみません）
        - 材料の右側にある買い物かごを押すと、材料をメモ帳に追加できるようになっています。
</br>
<p>
<img src="https://user-images.githubusercontent.com/123617091/232994652-bceb8556-c986-49dc-b9ee-3f43c19368d8.png" width="45%" />
<img src="https://user-images.githubusercontent.com/123617091/232995868-7b6fb0ad-0b72-44f2-986a-08e6b63815bb.png" width="45%" />
</p>
</br>

- レシピ追加遷移画面（左図）
    - レシピ追加画面に遷移するための画面
- レシピ追加画面（真ん中・右図）
    - タイトル・画像・カテゴリー・材料・作り方を入力して保存する画面

</br>
<p>
<img src="https://user-images.githubusercontent.com/123617091/233000631-2daead71-a9ed-42d9-8332-d0030366b220.png" width="32%" />
<img src="https://user-images.githubusercontent.com/123617091/233000785-e93ba4c1-5615-4e22-84e1-0fb0e0265ad1.png" width="32%" />
<img src="https://user-images.githubusercontent.com/123617091/233000941-ace8a2c7-63ce-4564-9628-bae5706f3663.png" width="32%" />
</p>
</br>

- メモ一覧画面（左図・真ん中）
    - 追加したメモを一覧で確認できる画面
- メモ追加画面（右図）
    - タスクを入力し保存する画面

</br>
<p>
<img src="https://user-images.githubusercontent.com/123617091/233003632-3ad3575a-a97e-4efb-acf1-056d1bb8d6bf.png" width="32%" />
<img src="https://user-images.githubusercontent.com/123617091/233004771-7ce8171d-0b90-4810-8cfd-6bf3d2d6c288.png" width="32%" />
<img src="https://user-images.githubusercontent.com/123617091/233004925-4907d02c-23ea-4f5d-b2c2-421468e30b6e.png" width="32%" />
</p>


# List Github Users
## 流程
1. 利用Insomnia測試github api => 使用 https://api.github.com/users?since={id}&per_page={size}
2. 查看JSON文件內的所有資料類型
3. 建立Model/User.swift => 定義User的資料型態
4. 建立ViewModel/UserViewModel => 寫getUsers功能，利用URLSession呼叫api(參數有 limit, since, pageSize)
5. ContentView onAppear時就fetch第一頁的資料(limit: 100, since: 0, pageSize: 20)並記錄此頁最後一位使用者id (lastUserId)
6. ContentView onAppear時開啟計時器(background thread)
7. 當用戶按下一頁按鈕，再次呼叫getUsers()，並把since參數帶入lastUserId，等待completion完更換lastUserId
8. 呼叫getUsers()會將fetch到的資料存進viewModel中的users陣列，直到達到limit為止(題目限定limit為100，因為數量較小所以選擇直接存存進陣列中)
9. 當點選完5頁時，100筆使用者資料會完整存進陣列中，並在ForEach中決定要顯示的資料為陣列中的哪幾筆 => 第一頁: 0~19、第二頁: 20~39、第三頁: 40~59...
10. 當用戶按上一頁，由於資料已在陣列中，不需要再call api
11. 建立View/UserInfoView => 用來顯示github user的詳細資料
12. list中每個row皆為button，用戶按下後即觸發popover，跳出UserInfoView


## 測試
### xcode simulator iPhone 12 Pro iOS15.5
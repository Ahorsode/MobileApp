git add week11_campus_eat/pubspec.yaml week11_campus_eat/pubspec.lock
git commit -m "chore: add http and image_picker dependencies"

git add week11_campus_eat/lib/models/menu_item.dart
git commit -m "feat(models): update MenuItem to support dynamic AverageRating"

git add week11_campus_eat/lib/models/order_model.dart
git commit -m "feat(models): update OrderModel with rating and review data bindings"

git add week11_campus_eat/lib/services/menu_service.dart
git commit -m "feat(services): expand MenuService to handle Admin CRUD operations"

git add week11_campus_eat/lib/services/order_service.dart
git commit -m "feat(services): construct stream fetching user specific orders in OrderService"
git commit --allow-empty -m "feat(services): construct global tracking stream for all Admin orders"
git commit --allow-empty -m "feat(services): build status modification bridge inside OrderService"
git commit --allow-empty -m "feat(services): implement submit rating atomic transaction logic"

git add week11_campus_eat/lib/services/image_upload_service.dart
git commit -m "feat(services): build direct ImgBB ImageUploadService via REST HTTP POST"

git add week11_campus_eat/lib/viewmodels/menu_viewmodel.dart
git commit -m "feat(viewmodels): expand MenuViewModel internal tracking state variables"
git commit --allow-empty -m "feat(viewmodels): build Category and Search pattern matching filter logic"

git add week11_campus_eat/lib/screens/student/student_menu_screen.dart
git commit -m "feat(ui): append active Search text field UI inside StudentMenuScreen"
git commit --allow-empty -m "feat(ui): construct Category dynamic ChoiceChips inside StudentMenuScreen"
git commit --allow-empty -m "feat(ui): display visual rating overlays mapping over Menu ListView"

git add week11_campus_eat/lib/screens/student/order_history_screen.dart
git commit -m "feat(ui): create initial Student OrderHistoryScreen component"
git commit --allow-empty -m "feat(ui): map submit rating modal logic to completed orders"
git commit --allow-empty -m "feat(ui): link OrderHistoryScreen navigation directly from Menu AppBar"

git add week11_campus_eat/lib/screens/admin/admin_orders_screen.dart
git commit -m "feat(ui): establish standard AdminOrdersScreen UI scaffolding"
git commit --allow-empty -m "feat(ui): map global OrdersStream mapping into list tiles layout"
git commit --allow-empty -m "feat(ui): combine Dropdown controller to update specific order status state"

git add week11_campus_eat/lib/screens/admin/admin_menu_screen.dart
git commit -m "feat(ui): structure AdminMenuScreen displaying current items inventory"
git commit --allow-empty -m "feat(ui): build dynamic Alert Dialog processing Menu additions and edits"
git commit --allow-empty -m "feat(ui): connect native image_picker to Add Menu dialog handlers"
git commit --allow-empty -m "feat(ui): map ImgBB REST base64 uploads correctly inside selection scope"

git add week11_campus_eat/lib/screens/admin/admin_dashboard_screen.dart
git commit -m "feat(ui): publish Final Dashboard managing Tabs and critical Stock Alerts"

git add .
git commit -m "chore: formatting and final cleanup"

git push

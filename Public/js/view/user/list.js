app.controller('UserListController', function($scope,$timeout) {
    $scope.data = {
        user:{},
        menu_arr:[],
        root_menu_arr:[]
    };
    $scope.get_page_data = function(){
        $.ajax({
            method:"GET",
            url:"/admin/currentUser",
            contentType: "application/json;",
            dataType:"json",
            data:{}
        }).done(function(result) {
            $timeout( function(){
                $scope.data.user = result;
            }, 0);
        })
        .fail(function() {
            alert("error");
        })
        .always(function() {
            
        });
    };
    $scope.init_data = function(){
        $scope.init_script();
    };
    $scope.init_script = function(){
        $('.footable').footable();
    };
    $scope.init_data();
});
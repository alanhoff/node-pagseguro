'use strict';

function HomeCrtl($scope, $http) {
	$scope.count = 0;
	$scope.total = 0.00;
	$scope.shopCar = [];

	$scope.items = [ { id:1, name: 'Github T-Shirt', price: 10.90, imageUrl: 'images/t-shirt.jpg', count: 0, weight: 2342  },
					 { id:2, name: 'Github T-Shirt', price: 10.90, imageUrl: 'images/t-shirt.jpg', count: 0, weight: 2342 },
					 { id:3, name: 'Github T-Shirt', price: 10.90, imageUrl: 'images/t-shirt.jpg', count: 0, weight: 2342 },
					 { id:4, name: 'Github T-Shirt', price: 10.90, imageUrl: 'images/t-shirt.jpg', count: 0, weight: 2342 },
					 { id:5, name: 'Github T-Shirt', price: 10.90, imageUrl: 'images/t-shirt.jpg', count: 0, weight: 2342 },
					 { id:6, name: 'Github T-Shirt', price: 10.90, imageUrl: 'images/t-shirt.jpg', count: 0, weight: 2342 }];

	$scope.addItem = function(item) {
		$scope.total += item.price;
		
		var hasItem = false;

 		angular.forEach($scope.shopCar, function(obj, key) {
			if (item.id == obj.id) {
				hasItem = true;
        		item.count++;
        	}
        });

		if ($scope.shopCar.length == 0 || !hasItem) {
			$scope.shopCar.push(item);	
			$scope.count++;	
			item.count++;
		}
	}

	$scope.checkOut = function() {

		$http.post('api/checkOut', $scope.shopCar)
			.success(function(data) {
		});
	}
}

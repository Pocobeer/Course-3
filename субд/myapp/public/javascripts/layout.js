$(document).ready(function(){

	$('#Logout').on('click', logout);
    $('#Login').on('click', login);
    $('#submit_login').click(function(e){
        e.preventDefault()
        var login_data = {
            login:    $('#inpLogin').val(),
            password: $('#inpPassword').val(),
        }

        $.ajax({
            type: 'POST',
            data: login_data,
            url: '/api/auth/login',
            dataType: 'JSON'
        }).done(function( response ) {

            if (response.msg === '') {
                window.location = "/";
            }
            else {
                alert(response.msg);
            }
        });
    })
});



function logout (e) {
	e.preventDefault()
	$.ajax({
		type: 'POST',
		url: '/api/auth/logout',
		dataType: 'JSON'
	}).done(function( response ) {
		window.location = "/";
	});
}

function login(e) {
    e.preventDefault()
    $('#login_popup').show()    
}
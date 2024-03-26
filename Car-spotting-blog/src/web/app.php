<?php
require '../vendor/autoload.php';
require '../Router.php';

$router = new Router();
$router->get('/addnewposts', 'PostController::new');
$router->get('/posts', 'PostController::index');
$router->post('/post', 'PostController::add');
$router->post('/register', 'LoginController::register');
$router->get('/registerscreen', 'LoginController::reginfo');
$router->post('/login', 'LoginController::login');
$router->get('/', 'LoginController::index');
$router->post('/logout', 'LoginController::logout');

$router->error404('ErrorController::error404');
$view = $router->dispatch();
$view->render();

<?php
require_once '../models/register.php';
require_once '../views/RedirectView.php';
require_once '../views/DiffPassView.php';
require_once '../views/SameLoginView.php';
require_once '../views/RegisterScreenView.php';

class LoginController 
{
    public function register()
    {
        $login = $_POST['login'];
        $email = $_POST['email'];
        $password1 = $_POST['password1'];
        $password2 = $_POST['password2'];
        
        $users = Register::getUsers();
        
        if($password1===$password2)
        {
            $usersNumber = count($users);
            for($i=0;$i<$usersNumber;$i++)
            {
                if($login==$users[$i]->login)
                {
                    return new SameLoginView();
                }
            }
            $hashedPassword = password_hash($password1, PASSWORD_DEFAULT);
            $register = new Register($login, $email, $hashedPassword);
            $register->save();
            session_start();
            $_SESSION['login'] = $login;
            return new RedirectView('index.php',303);
        }
        else
        {
            return new RedirectView('/registerscreen?differentPasswords=1',404);
        }
    }
    public function reginfo()
    {
        if(isset($_GET["differentPasswords"]))
        {
            return new DiffPassView();
        }
        else
        {
            return new RegisterScreenView();
        }
    }
    public function login()
    {
        $login = $_POST['login'];
        $password = $_POST['password'];
        $users = Register::getUsers();
        $usersNumber = count($users);
        for($i=0;$i<$usersNumber;$i++)
        {
            if($login==$users[$i]->login)
            {
                if( password_verify($password,$users[$i]->password) )
                {
                    session_start();
                    $_SESSION['login'] = $login;
                    return new RedirectView('index.php',303);
                }
                else
                    return new RedirectView('wrongpassword.php',404);
            }
        }
        return new RedirectView('nouser.php', 404);
    }
    public function index()
    {
        return new RedirectView('index.php',303);
    }
    public function logout()
    {
        session_start();
        $params = session_get_cookie_params();
        setcookie(session_name(), '', time() - 42000,
        $params["path"], $params["domain"],
        $params["secure"], $params["httponly"]
        );
        session_destroy();
        return new RedirectView('index.php',303);
    }
}
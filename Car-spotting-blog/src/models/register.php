<?php
require '../DataBase.php';

class Register
{
    public $login;
    public $email;
    public $password;
    private $_id;
    public function __construct($login, $email, $hashedPassword)
    {
        $this->login = $login;
        $this->email = $email;
        $this->password = $hashedPassword;
    }
    
    public function save()
    {
        $response = DataBase::get()->users->insertOne([
            'login' => $this->login,
            'email' => $this->email,
            'password' => $this->password
        ]);
        $this->_id = $response->getInsertedId();
    }
    
    public static function getUsers()
    {
        $response = DataBase::get()->users->find([]);
        $users = [];
        foreach ($response as $register)
        {
            $users[] = new Register($register['login'],$register['email'],$register['password']);
        }
        return $users;
    }
}
<?php
require_once '../views/ErrorScreenView.php';

class ErrorController
{
    public function error404()
    {
        return new ErrorScreenView();
    }
}
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;
/**
 *
 * @author IUHADU
 */
public class Constants {
    
    /**
     * Role Constants
     */
    public static final int ROLE_ADMIN = 1;
    public static final int ROLE_USER = 2;
    public static final int ROLE_MANAGER = 3;
    
    /**
     * User Status Constants
     */
    public static final int STATUS_ACTIVE = 1;
    public static final int STATUS_INACTIVE = 0;
    
    /**
     * URL Paths
     */
    public static final String URL_HOME = "home";
    public static final String URL_LOGIN = "login";
    public static final String URL_REGISTER = "register";
    public static final String URL_LOGOUT = "logout";
    public static final String URL_PROFILE = "profile";
    
    // Admin URLs
    public static final String URL_ADMIN_DASHBOARD = "admin/dashboard";
    public static final String URL_ADMIN_USERS = "admin/users";
    public static final String URL_ADMIN_PRODUCTS = "admin/products";
    
    /**
     * JSP Pages
     */
    public static final String PAGE_LOGIN = "login.jsp";
    public static final String PAGE_REGISTER = "register.jsp";
    public static final String PAGE_HOME = "home.jsp";
    public static final String PAGE_ERROR = "error.jsp";
    public static final String PAGE_403 = "403.jsp";
    
    /**
     * Message Constants
     */
    // Success messages
    public static final String MSG_LOGIN_SUCCESS = "Đăng nhập thành công!";
    public static final String MSG_REGISTER_SUCCESS = "Đăng ký tài khoản thành công!";
    public static final String MSG_UPDATE_SUCCESS = "Cập nhật thông tin thành công!";
    public static final String MSG_DELETE_SUCCESS = "Xóa thành công!";
    
    // Error messages
    public static final String MSG_LOGIN_FAILED = "Email hoặc mật khẩu không đúng!";
    public static final String MSG_EMAIL_EXISTS = "Email đã tồn tại trong hệ thống!";
    public static final String MSG_PHONE_EXISTS = "Số điện thoại đã tồn tại trong hệ thống!";
    public static final String MSG_PASSWORD_NOT_MATCH = "Mật khẩu xác nhận không khớp!";
    public static final String MSG_SYSTEM_ERROR = "Có lỗi xảy ra, vui lòng thử lại sau!";
    
    /**
     * Session Attributes
     */
    public static final String SESSION_USER = "user";
    public static final String SESSION_CART = "cart";
    public static final String SESSION_REDIRECT_URL = "redirectURL";
    
    /**
     * Request Attributes
     */
    public static final String ATTR_ERROR = "error";
    public static final String ATTR_SUCCESS = "success";
    public static final String ATTR_USER = "user";
    public static final String ATTR_USERS = "users";
    public static final String ATTR_PRODUCTS = "products";
    
    /**
     * Parameter Names
     */
    public static final String PARAM_EMAIL = "email";
    public static final String PARAM_PASSWORD = "password";
    public static final String PARAM_CONFIRM_PASSWORD = "confirmPassword";
    public static final String PARAM_FULL_NAME = "fullName";
    public static final String PARAM_PHONE = "phone";
    public static final String PARAM_PAGE = "page";
    public static final String PARAM_SIZE = "size";
    
    /**
     * File Upload Constants
     */
    public static final String UPLOAD_DIR = "uploads";
    public static final int MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    public static final String[] ALLOWED_FILE_TYPES = {
        "image/jpeg",
        "image/png",
        "image/gif"
    };
    
    /**
     * Pagination Constants
     */
    public static final int DEFAULT_PAGE_SIZE = 10;
    public static final int DEFAULT_PAGE_NUMBER = 1;
    
    /**
     * Date Format Patterns
     */
    public static final String DATE_FORMAT = "dd/MM/yyyy";
    public static final String DATE_TIME_FORMAT = "dd/MM/yyyy HH:mm:ss";
    
    /**
     * Regular Expressions
     */
    public static final String REGEX_EMAIL = "^[A-Za-z0-9+_.-]+@(.+)$";
    public static final String REGEX_PHONE = "(84|0[3|5|7|8|9])+([0-9]{8})\\b";
    public static final String REGEX_PASSWORD = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,}$";
    
    /**
     * Security Constants
     */
    public static final int PASSWORD_MIN_LENGTH = 8;
    public static final int LOGIN_MAX_ATTEMPTS = 3;
    public static final int LOGIN_LOCK_TIME = 15; // minutes
    
    /**
     * Other Constants
     */
    public static final String ENCODING_UTF8 = "UTF-8";
    public static final String CONTENT_TYPE_JSON = "application/json";
    public static final String CONTENT_TYPE_HTML = "text/html";
}


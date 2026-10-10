using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using Vegan.MVCWebApp.DuyLD.Models;
using Vegan.Services.DuyLD;

namespace Vegan.MVCWebApp.DuyLD.Controllers
{
    public class AccountController : Controller
    {
        private readonly ISystemUserAccountService _userAccountService;

        public AccountController(ISystemUserAccountService userAccountService)
        {
            _userAccountService = userAccountService;
        }

        public IActionResult Index()
        {
            return RedirectToAction(nameof(Login));
        }

        public IActionResult Login()
        {
            return View(new LoginRequest());
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginRequest request)
        {
            try
            {
                var userAccount = await _userAccountService.GetUserAccount(request.UserName, request.Password);

                if (userAccount != null)
                {
                    var claims = new List<Claim>
                    {
                        new(ClaimTypes.Name, userAccount.UserName),
                        new(ClaimTypes.Role, userAccount.RoleId.ToString())
                    };

                    var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
                    await HttpContext.SignInAsync(
                        CookieAuthenticationDefaults.AuthenticationScheme,
                        new ClaimsPrincipal(identity));

                    Response.Cookies.Append("UserName", userAccount.FullName);
                    Response.Cookies.Append("Role", userAccount.RoleId.ToString());

                    return RedirectToAction("Index", "VeganPlaceDuyLds");
                }
            }
            catch
            {
                // Keep the login page response generic.
            }

            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            ModelState.AddModelError("", "Login failure");
            return View(request);
        }

        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            Response.Cookies.Delete("UserName");
            Response.Cookies.Delete("Role");
            return RedirectToAction(nameof(Login), "Account");
        }

        public IActionResult Forbidden()
        {
            return View();
        }
    }
}

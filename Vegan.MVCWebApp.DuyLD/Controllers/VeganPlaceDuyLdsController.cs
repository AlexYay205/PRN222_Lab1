using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Vegan.Entities.DuyLD.Models;
using Vegan.Services.DuyLD;

namespace Vegan.MVCWebApp.DuyLD.Controllers
{
    public class VeganPlaceDuyLdsController : Controller
    {
        private readonly IVeganPlaceServiceDuyLd _veganPlaceService;

        public VeganPlaceDuyLdsController(IVeganPlaceServiceDuyLd veganPlaceService)
        {
            _veganPlaceService = veganPlaceService;
        }

        public async Task<IActionResult> Index(string? place, string? category, string? status)
        {
            var isActive = ParseStatus(status);
            var hasSearchCondition =
                !string.IsNullOrWhiteSpace(place)
                || !string.IsNullOrWhiteSpace(category)
                || isActive.HasValue;

            var items = hasSearchCondition
                ? await _veganPlaceService.GetAllAsync(place, category, isActive)
                : await _veganPlaceService.GetAllAsync();

            ViewData["PlaceSearch"] = place;
            ViewData["CategorySearch"] = category;
            ViewData["StatusSearch"] = status;

            return View(items);
        }

        public async Task<IActionResult> Details(long? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var veganPlaceDuyLd = await _veganPlaceService.GetByIdAsync(id.Value);
            if (veganPlaceDuyLd == null)
            {
                return NotFound();
            }

            return View(veganPlaceDuyLd);
        }

        public IActionResult Create()
        {
            return View(new VeganPlaceDuyLd
            {
                IsActive = true
            });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("VeganPlaceDuyLdid,CategoryName,CategoryDescription,CategoryDisplayOrder,PlaceName,Address,Phone,Website,Description,Latitude,Longitude,Rating,IsActive")] VeganPlaceDuyLd veganPlaceDuyLd)
        {
            if (ModelState.IsValid)
            {
                veganPlaceDuyLd.CreatedAt = DateTime.Now;
                await _veganPlaceService.CreateAsync(veganPlaceDuyLd);
                return RedirectToAction(nameof(Index));
            }

            return View(veganPlaceDuyLd);
        }

        public async Task<IActionResult> Edit(long? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var veganPlaceDuyLd = await _veganPlaceService.GetByIdAsync(id.Value);
            if (veganPlaceDuyLd == null)
            {
                return NotFound();
            }

            return View(veganPlaceDuyLd);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(long id, [Bind("VeganPlaceDuyLdid,CategoryName,CategoryDescription,CategoryDisplayOrder,PlaceName,Address,Phone,Website,Description,Latitude,Longitude,Rating,CreatedAt,IsActive")] VeganPlaceDuyLd veganPlaceDuyLd)
        {
            if (id != veganPlaceDuyLd.VeganPlaceDuyLdid)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    await _veganPlaceService.UpdateAsync(veganPlaceDuyLd);
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!await VeganPlaceDuyLdExistsAsync(veganPlaceDuyLd.VeganPlaceDuyLdid))
                    {
                        return NotFound();
                    }

                    throw;
                }

                return RedirectToAction(nameof(Index));
            }

            return View(veganPlaceDuyLd);
        }

        public async Task<IActionResult> Delete(long? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var veganPlaceDuyLd = await _veganPlaceService.GetByIdAsync(id.Value);
            if (veganPlaceDuyLd == null)
            {
                return NotFound();
            }

            return View(veganPlaceDuyLd);
        }

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(long id)
        {
            await _veganPlaceService.DeleteAsync(id);
            return RedirectToAction(nameof(Index));
        }

        private async Task<bool> VeganPlaceDuyLdExistsAsync(long id)
        {
            return await _veganPlaceService.GetByIdAsync(id) != null;
        }

        private static bool? ParseStatus(string? status)
        {
            if (string.IsNullOrWhiteSpace(status))
            {
                return null;
            }

            return status.Trim().ToLowerInvariant() switch
            {
                "active" or "act" or "true" or "1" or "yes" => true,
                "inactive" or "inact" or "false" or "0" or "no" => false,
                _ => null
            };
        }
    }
}

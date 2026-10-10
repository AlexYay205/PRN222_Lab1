using Microsoft.AspNetCore.SignalR;
using System.Text.Json;
using Vegan.Entities.DuyLD.Models;
using Vegan.Services.DuyLD;

namespace Vegan.MVCWebApp.DuyLD.Hubs
{
    public class VeganHub : Hub
    {
        private readonly IVeganPlaceServiceDuyLd _veganPlaceService;

        public VeganHub(IVeganPlaceServiceDuyLd veganPlaceService) =>
            _veganPlaceService = veganPlaceService;

        public async Task HubDelete_VeganPlaceServiceDuyLd(string id)
        {
            var result = await _veganPlaceService.DeleteAsync(long.Parse(id));

            if (result)
            {
                await Clients.All.SendAsync("Receiver_DeleteVeganPlaceServiceDuyLd", id);
            }
        }

        public async Task HubCreate_VeganPlaceServiceDuyLd(string dataObj)
        {
            var veganPlace = JsonSerializer.Deserialize<VeganPlaceDuyLd>(
                dataObj,
                new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                });

            if (veganPlace == null)
            {
                return;
            }

            veganPlace.CreatedAt = DateTime.Now;

            var result = await _veganPlaceService.CreateAsync(veganPlace);

            if (result > 0)
            {
                await Clients.All.SendAsync("Receiver_CreateVeganPlaceServiceDuyLd", veganPlace);
            }
        }

        public async Task HubUpdate_VeganPlaceServiceDuyLd(string dataObj)
        {
            var veganPlace = JsonSerializer.Deserialize<VeganPlaceDuyLd>(
                dataObj,
                new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                });

            if (veganPlace == null)
            {
                return;
            }

            var result = await _veganPlaceService.UpdateAsync(veganPlace);

            if (result > 0)
            {
                await Clients.All.SendAsync("Receiver_UpdateVeganPlaceServiceDuyLd", veganPlace);
            }
        }
    }
}

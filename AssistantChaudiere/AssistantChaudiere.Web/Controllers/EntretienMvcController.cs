using Microsoft.AspNetCore.Mvc;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json;
using System.Collections.Generic;
using AssistantChaudiere.Web.Models;

namespace AssistantChaudiere.Web.Controllers
{
    public class EntretienMvcController : Controller
    {
        private readonly HttpClient _httpClient;
        private readonly string _apiBaseUrl = "https://localhost:5001/api";

        public EntretienMvcController(IHttpClientFactory httpClientFactory)
        {
            _httpClient = httpClientFactory.CreateClient();
        }

        public async Task<IActionResult> Index()
        {
            var response = await _httpClient.GetAsync($"{_apiBaseUrl}/Entretien");
            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                var entretiens = JsonConvert.DeserializeObject<List<Entretien>>(content);
                return View(entretiens);
            }
            return View(new List<Entretien>());
        }

        public async Task<IActionResult> Create()
        {
            var response = await _httpClient.GetAsync($"{_apiBaseUrl}/Chaudiere");
            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                var chaudieres = JsonConvert.DeserializeObject<List<Chaudiere>>(content);
                ViewBag.Chaudieres = chaudieres;
            }
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Create(Entretien entretien)
        {
            if (ModelState.IsValid)
            {
                var response = await _httpClient.PostAsJsonAsync($"{_apiBaseUrl}/Entretien", entretien);
                if (response.IsSuccessStatusCode)
                {
                    return RedirectToAction(nameof(Index));
                }
            }
            return View(entretien);
        }

        public async Task<IActionResult> Edit(int id)
        {
            var response = await _httpClient.GetAsync($"{_apiBaseUrl}/Entretien/{id}");
            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                var entretien = JsonConvert.DeserializeObject<Entretien>(content);

                var chaudiereResponse = await _httpClient.GetAsync($"{_apiBaseUrl}/Chaudiere");
                if (chaudiereResponse.IsSuccessStatusCode)
                {
                    var chaudiereContent = await chaudiereResponse.Content.ReadAsStringAsync();
                    var chaudieres = JsonConvert.DeserializeObject<List<Chaudiere>>(chaudiereContent);
                    ViewBag.Chaudieres = chaudieres;
                }

                return View(entretien);
            }
            return NotFound();
        }

        [HttpPost]
        public async Task<IActionResult> Edit(int id, Entretien entretien)
        {
            if (ModelState.IsValid)
            {
                var response = await _httpClient.PutAsJsonAsync($"{_apiBaseUrl}/Entretien/{id}", entretien);
                if (response.IsSuccessStatusCode)
                {
                    return RedirectToAction(nameof(Index));
                }
            }
            return View(entretien);
        }

        public async Task<IActionResult> Delete(int id)
        {
            var response = await _httpClient.GetAsync($"{_apiBaseUrl}/Entretien/{id}");
            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                var entretien = JsonConvert.DeserializeObject<Entretien>(content);
                return View(entretien);
            }
            return NotFound();
        }

        [HttpPost, ActionName("Delete")]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var response = await _httpClient.DeleteAsync($"{_apiBaseUrl}/Entretien/{id}");
            if (response.IsSuccessStatusCode)
            {
                return RedirectToAction(nameof(Index));
            }
            return NotFound();
        }

        public async Task<IActionResult> ByChaudiere(int chaudiereId)
        {
            var response = await _httpClient.GetAsync($"{_apiBaseUrl}/Entretien/Chaudiere/{chaudiereId}");
            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                var entretiens = JsonConvert.DeserializeObject<List<Entretien>>(content);
                return View("Index", entretiens);
            }
            return View("Index", new List<Entretien>());
        }
    }
} 
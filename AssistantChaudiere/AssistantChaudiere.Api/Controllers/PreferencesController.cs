using Microsoft.AspNetCore.Mvc;
using System;
using System.IO;
using System.Threading.Tasks;
using System.Text.Json;
using Microsoft.Extensions.Configuration;

namespace AssistantChaudiere.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PreferencesController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly string _preferencesPath;

        public PreferencesController(IConfiguration configuration)
        {
            _configuration = configuration;
            _preferencesPath = Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),
                "AssistantChaudiere",
                "preferences.json"
            );
        }

        [HttpGet]
        public IActionResult Get()
        {
            try
            {
                if (!System.IO.File.Exists(_preferencesPath))
                {
                    return Ok(new Preferences());
                }

                var json = System.IO.File.ReadAllText(_preferencesPath);
                var preferences = JsonSerializer.Deserialize<Preferences>(json);
                return Ok(preferences);
            }
            catch (Exception ex)
            {
                return BadRequest($"Erreur lors de la lecture des préférences : {ex.Message}");
            }
        }

        [HttpPost("Save")]
        public IActionResult Save([FromBody] Preferences preferences)
        {
            try
            {
                var json = JsonSerializer.Serialize(preferences);
                Directory.CreateDirectory(Path.GetDirectoryName(_preferencesPath));
                System.IO.File.WriteAllText(_preferencesPath, json);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest($"Erreur lors de la sauvegarde des préférences : {ex.Message}");
            }
        }

        [HttpPost("UploadLogo")]
        public async Task<IActionResult> UploadLogo()
        {
            try
            {
                var file = Request.Form.Files[0];
                if (file == null || file.Length == 0)
                {
                    return BadRequest("Aucun fichier n'a été uploadé");
                }

                var uploadsPath = Path.Combine(
                    Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),
                    "AssistantChaudiere",
                    "uploads"
                );
                Directory.CreateDirectory(uploadsPath);

                var fileName = $"logo_{DateTime.Now:yyyyMMddHHmmss}{Path.GetExtension(file.FileName)}";
                var filePath = Path.Combine(uploadsPath, fileName);

                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await file.CopyToAsync(stream);
                }

                return Ok(new { logoUrl = $"/uploads/{fileName}" });
            }
            catch (Exception ex)
            {
                return BadRequest($"Erreur lors de l'upload du logo : {ex.Message}");
            }
        }

        [HttpGet("ExportData")]
        public IActionResult ExportData()
        {
            try
            {
                if (!System.IO.File.Exists(_preferencesPath))
                {
                    return NotFound("Aucune donnée à exporter");
                }

                var json = System.IO.File.ReadAllText(_preferencesPath);
                var bytes = System.Text.Encoding.UTF8.GetBytes(json);
                return File(bytes, "application/json", "preferences_backup.json");
            }
            catch (Exception ex)
            {
                return BadRequest($"Erreur lors de l'export des données : {ex.Message}");
            }
        }

        [HttpPost("ImportData")]
        public async Task<IActionResult> ImportData()
        {
            try
            {
                var file = Request.Form.Files[0];
                if (file == null || file.Length == 0)
                {
                    return BadRequest("Aucun fichier n'a été uploadé");
                }

                using (var stream = new MemoryStream())
                {
                    await file.CopyToAsync(stream);
                    var json = System.Text.Encoding.UTF8.GetString(stream.ToArray());
                    var preferences = JsonSerializer.Deserialize<Preferences>(json);

                    Directory.CreateDirectory(Path.GetDirectoryName(_preferencesPath));
                    System.IO.File.WriteAllText(_preferencesPath, json);

                    return Ok(preferences);
                }
            }
            catch (Exception ex)
            {
                return BadRequest($"Erreur lors de l'import des données : {ex.Message}");
            }
        }

        [HttpPost("ClearData")]
        public IActionResult ClearData()
        {
            try
            {
                if (System.IO.File.Exists(_preferencesPath))
                {
                    System.IO.File.Delete(_preferencesPath);
                }
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest($"Erreur lors de l'effacement des données : {ex.Message}");
            }
        }
    }

    public class Preferences
    {
        public string TechnicianName { get; set; }
        public string Theme { get; set; } = "light";
        public string TemperatureUnit { get; set; } = "celsius";
        public string DefaultModule { get; set; }
        public bool AutoSave { get; set; }
        public bool OfflineMode { get; set; }
        public string CompanyLogo { get; set; }
    }
} 
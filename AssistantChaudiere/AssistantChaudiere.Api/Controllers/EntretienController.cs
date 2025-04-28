using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using AssistantChaudiere.Api.Data;
using AssistantChaudiere.Api.Models;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AssistantChaudiere.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EntretienController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public EntretienController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/Entretien
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Entretien>>> GetEntretiens()
        {
            return await _context.Entretiens
                .Include(e => e.Chaudiere)
                .ToListAsync();
        }

        // GET: api/Entretien/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Entretien>> GetEntretien(int id)
        {
            var entretien = await _context.Entretiens
                .Include(e => e.Chaudiere)
                .FirstOrDefaultAsync(e => e.Id == id);

            if (entretien == null)
            {
                return NotFound();
            }

            return entretien;
        }

        // GET: api/Entretien/Chaudiere/5
        [HttpGet("Chaudiere/{chaudiereId}")]
        public async Task<ActionResult<IEnumerable<Entretien>>> GetEntretiensByChaudiere(int chaudiereId)
        {
            return await _context.Entretiens
                .Where(e => e.ChaudiereId == chaudiereId)
                .ToListAsync();
        }

        // PUT: api/Entretien/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutEntretien(int id, Entretien entretien)
        {
            if (id != entretien.Id)
            {
                return BadRequest();
            }

            _context.Entry(entretien).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!EntretienExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Entretien
        [HttpPost]
        public async Task<ActionResult<Entretien>> PostEntretien(Entretien entretien)
        {
            _context.Entretiens.Add(entretien);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetEntretien", new { id = entretien.Id }, entretien);
        }

        // DELETE: api/Entretien/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteEntretien(int id)
        {
            var entretien = await _context.Entretiens.FindAsync(id);
            if (entretien == null)
            {
                return NotFound();
            }

            _context.Entretiens.Remove(entretien);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool EntretienExists(int id)
        {
            return _context.Entretiens.Any(e => e.Id == id);
        }
    }
} 
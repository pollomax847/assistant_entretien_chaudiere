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
    public class ChaudiereController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public ChaudiereController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/Chaudiere
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Chaudiere>>> GetChaudieres()
        {
            return await _context.Chaudieres.ToListAsync();
        }

        // GET: api/Chaudiere/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Chaudiere>> GetChaudiere(int id)
        {
            var chaudiere = await _context.Chaudieres.FindAsync(id);

            if (chaudiere == null)
            {
                return NotFound();
            }

            return chaudiere;
        }

        // PUT: api/Chaudiere/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutChaudiere(int id, Chaudiere chaudiere)
        {
            if (id != chaudiere.Id)
            {
                return BadRequest();
            }

            _context.Entry(chaudiere).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ChaudiereExists(id))
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

        // POST: api/Chaudiere
        [HttpPost]
        public async Task<ActionResult<Chaudiere>> PostChaudiere(Chaudiere chaudiere)
        {
            _context.Chaudieres.Add(chaudiere);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetChaudiere", new { id = chaudiere.Id }, chaudiere);
        }

        // DELETE: api/Chaudiere/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteChaudiere(int id)
        {
            var chaudiere = await _context.Chaudieres.FindAsync(id);
            if (chaudiere == null)
            {
                return NotFound();
            }

            _context.Chaudieres.Remove(chaudiere);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ChaudiereExists(int id)
        {
            return _context.Chaudieres.Any(e => e.Id == id);
        }
    }
} 
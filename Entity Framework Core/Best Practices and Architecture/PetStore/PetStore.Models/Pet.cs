using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;
using PetStore.Common;
using PetStore.Models.Enumerations;

namespace PetStore.Models
{
    public class Pet
    {
        public Pet()
        {
            this.Id = Guid.NewGuid().ToString();
        }

        [Key]
        public string Id { get; set; }

        [Required]
        [MinLength(GlobalConstants.PetNameMinLength)]
        public string Name { get; set; }
        public Gender Gender { get; set; }

        [Range(GlobalConstants.PetMinAge,GlobalConstants.PetMaxAge)]
        public byte Age { get; set; }

        [Required]
        [ForeignKey(nameof(Breed))]
        public int BreedId { get; set; }
        public virtual Breed Breed { get; set; }
        public bool IsSold { get; set; }

        [ForeignKey(nameof(Client))]
        public string ClientId { get; set; }
        public Client Client { get; set; }

        [Range(GlobalConstants.SellableMinPrice,Double.MaxValue)]
        public decimal Price { get; set; }
    }
}

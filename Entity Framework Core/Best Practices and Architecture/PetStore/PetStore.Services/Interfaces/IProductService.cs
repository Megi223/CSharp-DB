using System;
using System.Collections.Generic;
using System.Text;
using PetStore.Models;
using PetStore.ServiceModels.Products.InputModels;
using PetStore.ServiceModels.Products.OutputModels;

namespace PetStore.Services.Interfaces
{
    public interface IProductService
    {
        void AddProduct(AddProductInputServiceModel model);

        ProductDetailsServiceModel GetById(string id);
        ICollection<ListAllProductsByProductTypeServiceModel> ListAllByProductType(string type);

        ICollection<ListAllProductsServiceModel> GetAll();

        bool RemoveById(string id);

        bool RemoveByName(string name);

        ICollection<ListAllProductsByNameServiceModel> SearchByName(string searchStr, bool caseSensitive);

        void Edit(string id, EditProductInputServiceModel model);
    }
}

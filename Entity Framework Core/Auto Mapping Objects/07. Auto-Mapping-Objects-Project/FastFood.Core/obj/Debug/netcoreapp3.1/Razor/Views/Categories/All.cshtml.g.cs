#pragma checksum "D:\SoftUni\C# DB\EF Core\Auto Mapping Objects\07. Auto-Mapping-Objects-Project\FastFood.Core\Views\Categories\All.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "76c9b66b0436ed29d1cfcbcb7452b4926fde155c"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_Categories_All), @"mvc.1.0.view", @"/Views/Categories/All.cshtml")]
namespace AspNetCore
{
    #line hidden
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.AspNetCore.Mvc.Rendering;
    using Microsoft.AspNetCore.Mvc.ViewFeatures;
#nullable restore
#line 1 "D:\SoftUni\C# DB\EF Core\Auto Mapping Objects\07. Auto-Mapping-Objects-Project\FastFood.Core\Views\_ViewImports.cshtml"
using FastFood.Core;

#line default
#line hidden
#nullable disable
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"76c9b66b0436ed29d1cfcbcb7452b4926fde155c", @"/Views/Categories/All.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"4ed879bff0478396c899ea94a6589fe8b9c42e19", @"/Views/_ViewImports.cshtml")]
    public class Views_Categories_All : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<IList<FastFood.Core.ViewModels.Categories.CategoryAllViewModel>>
    {
        #line hidden
        #pragma warning disable 0649
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperExecutionContext __tagHelperExecutionContext;
        #pragma warning restore 0649
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperRunner __tagHelperRunner = new global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperRunner();
        #pragma warning disable 0169
        private string __tagHelperStringValueBuffer;
        #pragma warning restore 0169
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperScopeManager __backed__tagHelperScopeManager = null;
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperScopeManager __tagHelperScopeManager
        {
            get
            {
                if (__backed__tagHelperScopeManager == null)
                {
                    __backed__tagHelperScopeManager = new global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperScopeManager(StartTagHelperWritingScope, EndTagHelperWritingScope);
                }
                return __backed__tagHelperScopeManager;
            }
        }
        private global::Microsoft.AspNetCore.Mvc.Razor.TagHelpers.HeadTagHelper __Microsoft_AspNetCore_Mvc_Razor_TagHelpers_HeadTagHelper;
        private global::Microsoft.AspNetCore.Mvc.Razor.TagHelpers.BodyTagHelper __Microsoft_AspNetCore_Mvc_Razor_TagHelpers_BodyTagHelper;
        #pragma warning disable 1998
        public async override global::System.Threading.Tasks.Task ExecuteAsync()
        {
            WriteLiteral("\r\n");
#nullable restore
#line 3 "D:\SoftUni\C# DB\EF Core\Auto Mapping Objects\07. Auto-Mapping-Objects-Project\FastFood.Core\Views\Categories\All.cshtml"
  
    ViewData["Title"] = "All Categories";

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n\r\n\r\n<!DOCTYPE html>\r\n<html lang=\"en\">\r\n\r\n");
            __tagHelperExecutionContext = __tagHelperScopeManager.Begin("head", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.StartTagAndEndTag, "76c9b66b0436ed29d1cfcbcb7452b4926fde155c3516", async() => {
                WriteLiteral("\r\n\r\n    <meta charset=\"utf-8\">\r\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1, shrink-to-fit=no\">\r\n    <meta name=\"description\"");
                BeginWriteAttribute("content", " content=\"", 325, "\"", 335, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n    <meta name=\"author\"");
                BeginWriteAttribute("content", " content=\"", 362, "\"", 372, 0);
                EndWriteAttribute();
                WriteLiteral(@">

    <title>Categories</title>

    <!-- Bootstrap core CSS -->
    <link href=""vendor/bootstrap/css/bootstrap.min.css"" rel=""stylesheet"">

    <!-- Custom fonts for this template -->
    <link href=""https://fonts.googleapis.com/css?family=Raleway:100,100i,200,200i,300,300i,400,400i,500,500i,600,600i,700,700i,800,800i,900,900i"" rel=""stylesheet"">
    <link href=""https://fonts.googleapis.com/css?family=Lora:400,400i,700,700i"" rel=""stylesheet"">

    <!-- Custom styles for this template -->
    <link href=""css/business-casual.min.css"" rel=""stylesheet"">

");
            }
            );
            __Microsoft_AspNetCore_Mvc_Razor_TagHelpers_HeadTagHelper = CreateTagHelper<global::Microsoft.AspNetCore.Mvc.Razor.TagHelpers.HeadTagHelper>();
            __tagHelperExecutionContext.Add(__Microsoft_AspNetCore_Mvc_Razor_TagHelpers_HeadTagHelper);
            await __tagHelperRunner.RunAsync(__tagHelperExecutionContext);
            if (!__tagHelperExecutionContext.Output.IsContentModified)
            {
                await __tagHelperExecutionContext.SetOutputContentAsync();
            }
            Write(__tagHelperExecutionContext.Output);
            __tagHelperExecutionContext = __tagHelperScopeManager.End();
            WriteLiteral("\r\n\r\n");
            __tagHelperExecutionContext = __tagHelperScopeManager.Begin("body", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.StartTagAndEndTag, "76c9b66b0436ed29d1cfcbcb7452b4926fde155c5580", async() => {
                WriteLiteral(@"



    <h1 class=""text-center text-white d-none d-lg-block site-heading"">All Categories</h1>
    <hr class=""hr-2"" />

   
<table class=""table mx-auto"">
    <thead>
    <tr class=""row"">
        <th class=""col-md-1"">#</th>
        <th class=""col-md-2"">Category</th>
    </tr>
    </thead>
    <tbody>
");
#nullable restore
#line 49 "D:\SoftUni\C# DB\EF Core\Auto Mapping Objects\07. Auto-Mapping-Objects-Project\FastFood.Core\Views\Categories\All.cshtml"
     for (var i = 0; i < Model.Count(); i++)
    {

#line default
#line hidden
#nullable disable
                WriteLiteral("        <tr class=\"row\">\r\n            <th class=\"col-md-1\">");
#nullable restore
#line 52 "D:\SoftUni\C# DB\EF Core\Auto Mapping Objects\07. Auto-Mapping-Objects-Project\FastFood.Core\Views\Categories\All.cshtml"
                             Write(i+1);

#line default
#line hidden
#nullable disable
                WriteLiteral("</th>\r\n            <td class=\"col-md-2\">");
#nullable restore
#line 53 "D:\SoftUni\C# DB\EF Core\Auto Mapping Objects\07. Auto-Mapping-Objects-Project\FastFood.Core\Views\Categories\All.cshtml"
                            Write(Model[i].Name);

#line default
#line hidden
#nullable disable
                WriteLiteral("</td>\r\n        </tr>\r\n");
#nullable restore
#line 55 "D:\SoftUni\C# DB\EF Core\Auto Mapping Objects\07. Auto-Mapping-Objects-Project\FastFood.Core\Views\Categories\All.cshtml"
    }

#line default
#line hidden
#nullable disable
                WriteLiteral("    </tbody>\r\n</table>\r\n\r\n    <footer class=\"footer text-faded text-center py-5\">\r\n        <div class=\"container body-content\">\r\n            <p>&copy; ");
#nullable restore
#line 61 "D:\SoftUni\C# DB\EF Core\Auto Mapping Objects\07. Auto-Mapping-Objects-Project\FastFood.Core\Views\Categories\All.cshtml"
                 Write(DateTime.Now.Year);

#line default
#line hidden
#nullable disable
                WriteLiteral(" - My ASP.NET Application</p>\r\n        </div>\r\n    </footer>\r\n\r\n    <!-- Bootstrap core JavaScript -->\r\n    <script src=\"vendor/jquery/jquery.min.js\"></script>\r\n    <script src=\"vendor/bootstrap/js/bootstrap.bundle.min.js\"></script>\r\n\r\n");
            }
            );
            __Microsoft_AspNetCore_Mvc_Razor_TagHelpers_BodyTagHelper = CreateTagHelper<global::Microsoft.AspNetCore.Mvc.Razor.TagHelpers.BodyTagHelper>();
            __tagHelperExecutionContext.Add(__Microsoft_AspNetCore_Mvc_Razor_TagHelpers_BodyTagHelper);
            await __tagHelperRunner.RunAsync(__tagHelperExecutionContext);
            if (!__tagHelperExecutionContext.Output.IsContentModified)
            {
                await __tagHelperExecutionContext.SetOutputContentAsync();
            }
            Write(__tagHelperExecutionContext.Output);
            __tagHelperExecutionContext = __tagHelperScopeManager.End();
            WriteLiteral("\r\n\r\n</html>\r\n");
        }
        #pragma warning restore 1998
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.ViewFeatures.IModelExpressionProvider ModelExpressionProvider { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IUrlHelper Url { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IViewComponentHelper Component { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IJsonHelper Json { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<IList<FastFood.Core.ViewModels.Categories.CategoryAllViewModel>> Html { get; private set; }
    }
}
#pragma warning restore 1591

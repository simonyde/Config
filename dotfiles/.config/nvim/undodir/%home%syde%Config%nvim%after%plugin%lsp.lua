Vim�UnDo� 	�+��|���xy��X.˴�GNS��#�,�k�                                      dYy�     _�                      
        ����                                                                                                                                                                                                                                                                                                                                                             dYy�     �                  %local nvim_lsp = require('lspconfig')               -- Cmp Setup   @local capabilities = vim.lsp.protocol.make_client_capabilities()   Icapabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)       -- Language setup   Cservers = {"texlab", "pylsp", "nil_ls", "rust_analyzer", "metals" }    for _, lsp in ipairs(servers) do       nvim_lsp[lsp].setup {   $        capabilities = capabilities,       }   end5�5��
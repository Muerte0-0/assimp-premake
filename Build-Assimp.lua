function generateConfigHeader(input, output, defines, replacements)
    os.mkdir(path.getdirectory(output))

    local file = io.open(input, "r")
    if not file then
        error("Failed to open " .. input)
    end

    local content = file:read("*all")
    file:close()

    defines = defines or {}
    replacements = replacements or {}

    -- Handle #cmakedefine01
    content = content:gsub("#cmakedefine01%s+(%w+)", function(def)
        if defines[def] == false then
            return "#define " .. def .. " 0"
        else
            return "#define " .. def .. " 1"
        end
    end)

    -- Handle #cmakedefine
    content = content:gsub("#cmakedefine%s+(%w+)", function(def)
        if defines[def] == false then
            return "/* #undef " .. def .. " */"
        else
            return "#define " .. def
        end
    end)

    -- Handle @TOKEN@ replacements
    for key, value in pairs(replacements) do
    content = content:gsub("@" .. key .. "@", value)
	end
	
	content = content:gsub("@[%w_]+@", "")

    local out = io.open(output, "w")
    out:write(content)
    out:close()

    print("Generated: " .. output)
end

-- Assimp config
generateConfigHeader(
    "include/assimp/config.h.in",
    "_config_headers/assimp/config.h",
    {
        ASSIMP_BUILD_NO_EXPORT = true,
        ASSIMP_BUILD_DLL_EXPORT = false
    },{}
)

generateConfigHeader(
    "include/assimp/revision.h.in",
    "_config_headers/assimp/revision.h",
    {},
    {
        GIT_COMMIT_HASH = "0",
        GIT_BRANCH = "master",

        ASSIMP_VERSION_MAJOR = "6",
        ASSIMP_VERSION_MINOR = "0",
        ASSIMP_VERSION_PATCH = "4",
        ASSIMP_PACKAGE_VERSION = "0",

        CMAKE_SHARED_LIBRARY_PREFIX = "",
        LIBRARY_SUFFIX = "",
        CMAKE_DEBUG_POSTFIX = "d"
    }
)

-- Zlib config (zconf.h)
generateConfigHeader(
    "contrib/zlib/zconf.h.in",
    "_config_headers/zlib/zconf.h",
    {
        -- Add flags if needed
    },{}
)

project "Assimp"
    kind "StaticLib"
    language "C++"
    cppdialect "C++17"

targetdir (ThirdPartyBinDir)
objdir (ThirdPartyIntDir)

disablewarnings { "4244" }

includedirs
{
	'_config_headers/',
	'_config_headers/assimp/',
	'_config_headers/zlib/',
	'./',
	'contrib/',
	'contrib/irrXML/',
	'contrib/unzip/',
	'contrib/rapidjson/include/',
	'contrib/pugixml/src/',
	'contrib/zlib/',
	'contrib/utf8cpp/source',
	'code',
	'include',
}

files
{
	-- Dependencies
	'contrib/unzip/**',
	'contrib/irrXML/**',
	'contrib/zlib/*',
	'contrib/pugixml/src/*',
	
	-- Common
	'code/Common/**',
	'code/PostProcessing/**',
	'code/Material/**',
	'code/CApi/**',
	'code/Geometry/**',
	
	-- Importers (only include source for importers that are actually enabled)
	'code/AssetLib/IQM/**',
	'code/AssetLib/Assbin/**',
	'code/AssetLib/Collada/**',
	'code/AssetLib/Obj/**',
	'code/AssetLib/FBX/**',
	'code/AssetLib/glTF/**',
	'code/AssetLib/glTF2/**',
	'code/AssetLib/glTFCommon/**',
}

removefiles
{
    "code/Exporter/**",
    "code/*Exporter.*",
    "code/*Export.*",
}

defines
{
    "_CRT_SECURE_NO_WARNINGS",
    "RAPIDJSON_HAS_STDSTRING=1",
    "ASSIMP_STATIC",
    "ASSIMP_BUILD_NO_EXPORT",

    -- ---- Disabled importers (not needed, keep compile times low) ----
    "ASSIMP_BUILD_NO_USD_IMPORTER",
    "ASSIMP_BUILD_NO_PBRT_IMPORTER",
    "ASSIMP_BUILD_NO_3D_IMPORTER",
    "ASSIMP_BUILD_NO_3DS_IMPORTER",
    "ASSIMP_BUILD_NO_3MF_IMPORTER",
    "ASSIMP_BUILD_NO_AC_IMPORTER",
    "ASSIMP_BUILD_NO_AMF_IMPORTER",
    "ASSIMP_BUILD_NO_ASE_IMPORTER",
    "ASSIMP_BUILD_NO_B3D_IMPORTER",
    "ASSIMP_BUILD_NO_BLEND_IMPORTER",
    "ASSIMP_BUILD_NO_BVH_IMPORTER",
    "ASSIMP_BUILD_NO_C4D_IMPORTER",
    "ASSIMP_BUILD_NO_COB_IMPORTER",
    "ASSIMP_BUILD_NO_CSM_IMPORTER",
    "ASSIMP_BUILD_NO_DXF_IMPORTER",
    "ASSIMP_BUILD_NO_HMP_IMPORTER",
    "ASSIMP_BUILD_NO_IFC_IMPORTER",
    "ASSIMP_BUILD_NO_IRR_IMPORTER",
    "ASSIMP_BUILD_NO_IRRMESH_IMPORTER",
    "ASSIMP_BUILD_NO_LWO_IMPORTER",
    "ASSIMP_BUILD_NO_LWS_IMPORTER",
    "ASSIMP_BUILD_NO_M3D_IMPORTER",
    "ASSIMP_BUILD_NO_MD2_IMPORTER",
    "ASSIMP_BUILD_NO_MD3_IMPORTER",
    "ASSIMP_BUILD_NO_MD5_IMPORTER",
    "ASSIMP_BUILD_NO_MDC_IMPORTER",
    "ASSIMP_BUILD_NO_MDL_IMPORTER",
    "ASSIMP_BUILD_NO_MMD_IMPORTER",
    "ASSIMP_BUILD_NO_MS3D_IMPORTER",
    "ASSIMP_BUILD_NO_NDO_IMPORTER",
    "ASSIMP_BUILD_NO_NFF_IMPORTER",
    "ASSIMP_BUILD_NO_OFF_IMPORTER",
    "ASSIMP_BUILD_NO_OGRE_IMPORTER",
    "ASSIMP_BUILD_NO_OPENGEX_IMPORTER",
    "ASSIMP_BUILD_NO_PLY_IMPORTER",
    "ASSIMP_BUILD_NO_Q3BSP_IMPORTER",
    "ASSIMP_BUILD_NO_Q3D_IMPORTER",
    "ASSIMP_BUILD_NO_RAW_IMPORTER",
    "ASSIMP_BUILD_NO_SIB_IMPORTER",
    "ASSIMP_BUILD_NO_SMD_IMPORTER",
    "ASSIMP_BUILD_NO_STEP_IMPORTER",
    "ASSIMP_BUILD_NO_STL_IMPORTER",
    "ASSIMP_BUILD_NO_TERRAGEN_IMPORTER",
    "ASSIMP_BUILD_NO_X_IMPORTER",
    "ASSIMP_BUILD_NO_X3D_IMPORTER",
    "ASSIMP_BUILD_NO_XGL_IMPORTER",

    -- ---- Enabled Importers ----
    -- "ASSIMP_BUILD_NO_OBJ_IMPORTER",
    -- "ASSIMP_BUILD_NO_FBX_IMPORTER",
    -- "ASSIMP_BUILD_NO_GLTF_IMPORTER",
    -- "ASSIMP_BUILD_NO_COLLADA_IMPORTER",
    -- "ASSIMP_BUILD_NO_ASSBIN_IMPORTER",
}

filter "system:linux"
	defines { "HAVE_UNISTD_H" }
	
filter "configurations:Debug"
	defines "KE_DEBUG"
	runtime "Debug"
	symbols "on"

filter "configurations:Release"
	defines "KE_RELEASE"
	runtime "Release"
	optimize "on"

filter "configurations:Dist"
	defines "KE_DIST"
	runtime "Release"
	optimize "on"

-- vim:set foldmethod=marker:
local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node
local l = require("luasnip.extras").lambda
local c = luasnip.choice_node
local r = require("luasnip.extras").rep

-- helpers {{{
---@param filepath string
---@return string
local function get_class_under_test(filepath)
  local class_under_test = string.gsub(filepath, "Test.php", "")
  class_under_test = string.gsub(filepath, "Spec.php", "")
  class_under_test = string.gsub(class_under_test, vim.api.nvim_exec("pwd", true), "")
  class_under_test = string.gsub(class_under_test, "/project/Zed/tests/src/", "")
  class_under_test = string.gsub(class_under_test, "/spec/", "Palette/")
  class_under_test = string.gsub(class_under_test, "^/(.*)$", "%1")
  class_under_test = string.gsub(class_under_test, "/", "\\")

  return class_under_test
end

---@param filepath string
---@param filename string
---@return string
local function get_namespace(filepath, filename)
  local namespace = string.gsub(filepath, "/" .. filename, "")
  namespace = string.gsub(namespace, vim.api.nvim_exec("pwd", true), "")
  -- TODO: get SUPER fancy with this and use jq to parse composer.json autoload psr-4, then map that to replacing paths
  namespace = string.gsub(namespace, "^/app/(.*)$", "Palette/%1")
  namespace = string.gsub(namespace, "^/spec/(.*)$", "spec/Palette/%1")
  namespace = string.gsub(namespace, "/project/Zed/tests", "Tests")
  namespace = string.gsub(namespace, "SaatchiArt", "SaatchiArt")
  namespace = string.gsub(namespace, "/project/Zed/src/", "")
  namespace = string.gsub(namespace, "^/(.*)$", "%1")
  namespace = string.gsub(namespace, "/", "\\")

  return namespace
end
-- }}}

-- class {{{
local class_snippet = s({ trig = "cla", name = "PHP Class", dscr = "Mike's class with namespace" }, {
  t({
    "<?php",
    "",
    "declare(strict_types=1);",
    "",
    "",
  }),
  f(function(_, snip)
    local namespace = get_namespace(snip.env.TM_FILEPATH, snip.env.TM_FILENAME)

    return "namespace " .. namespace .. ";"
  end, {}),
  t({ "", "", "" }),
  c(1, {
    t("final "),
    t(""),
  }),
  f(function(_, snip)
    local class_name = string.gsub(snip.env.TM_FILENAME, ".php", "")

    return "class " .. class_name
  end, {}),
  t({ "", "{", "    " }),
  i(0),
  t({ "", "}" }),
})
-- }}}

-- controller {{{
local controller_snippet = s({ trig = "cntr", name = "PHP Class", dscr = "Mike's controller" }, {
  t({
    "<?php",
    "",
    "declare(strict_types=1);",
    "",
    "",
  }),
  f(function(_, snip)
    local namespace = get_namespace(snip.env.TM_FILEPATH, snip.env.TM_FILENAME)

    return "namespace " .. namespace .. ";"
  end, {}),
  t({ "", "", "" }),
  t({ "use Illuminate\\Http\\JsonResponse;", "" }),
  t({ "use Palette\\Http\\Controllers\\Controller;", "" }),
  t({ "", "" }),
  f(function(_, snip)
    local class_name = string.gsub(snip.env.TM_FILENAME, ".php", "")

    return "final class " .. class_name .. " extends Controller"
  end, {}),
  t({ "", "{", "    " }),
  i(0),
  t({ "", "}" }),
})
-- }}}

-- artisan command {{{
local artisan_snippet = s(
  { trig = "art", name = "Laravel artisan command", dscr = "Laravel artisan command with namespace" },
  {
    t({
      "<?php",
      "",
      "declare(strict_types=1);",
      "",
      "",
    }),
    f(function(_, snip)
      local namespace = get_namespace(snip.env.TM_FILEPATH, snip.env.TM_FILENAME)

      return "namespace " .. namespace .. ";"
    end, {}),
    t({ "", "", "" }),
    t({ "use Illuminate\\Console\\Command;" }),
    t({ "", "", "" }),
    f(function(_, snip)
      local class_name = string.gsub(snip.env.TM_FILENAME, ".php", "")

      return "class " .. class_name .. " extends Command"
    end, {}),
    t({ "", "{", "    " }),
    t({ "/** @inheritDoc */", "    protected $signature = '" }),
    i(1, "one-timers:do-something"),
    t({ " {--dry-run}';", "", "" }),
    t({ "    /** @inheritDoc */", "    protected $description = '" }),
    i(2, "Does something"),
    t({ "';", "", "" }),
    t({ "    /** @inheritDoc */", "" }),
    t({ "    public function handle()", "    {", "" }),
    t({
      "        if ($this->option('dry-run')) {",
      "            $this->info('Dry run only, no changes will be made');",
      "        }",
      "",
      "",
    }),
    t({ "        " }),
    i(3),
    t({ "", "    }" }),
    t({ "", "}" }),
  }
)
-- }}}

-- interface {{{
local interface_snippet = s({ trig = "inte", name = "PHP Interface", dscr = "Mike's interface with namespace" }, {
  t({
    "<?php",
    "",
    "declare(strict_types=1);",
    "",
    "",
  }),
  f(function(_, snip)
    local namespace = get_namespace(snip.env.TM_FILEPATH, snip.env.TM_FILENAME)

    return "namespace " .. namespace .. ";"
  end, {}),
  t({ "", "", "" }),
  f(function(_, snip)
    local interface_name = string.gsub(snip.env.TM_FILENAME, ".php", "")

    return "interface " .. interface_name
  end, {}),
  t({ "", "{", "    " }),
  i(0),
  t({ "", "}" }),
})
-- }}}

-- phpunit class {{{
local phpunit_class_snippet = s(
  { trig = "pucla", name = "PHPUnit Class", dscr = "Mike's phpunit class with namespace" },
  {
    t({
      "<?php",
      "",
      "declare(strict_types=1);",
      "",
      "",
    }),
    f(function(_, snip)
      local namespace = get_namespace(snip.env.TM_FILEPATH, snip.env.TM_FILENAME)

      return "namespace " .. namespace .. ";"
    end, {}),
    f(function(_, snip)
      local class_under_test = get_class_under_test(snip.env.TM_FILEPATH)
      return {
        "",
        "",
        "use PHPUnit\\Framework\\TestCase;",
        "use Prophecy\\Argument;",
        "use " .. class_under_test .. ";",
        "",
        "/**",
        " * @final",
        " *",
        " * ",
      }
    end),
    f(function(_, snip)
      local class_under_test = get_class_under_test(snip.env.TM_FILEPATH)

      return "@see " .. class_under_test
    end, {}),
    t({ "", " */", "" }),
    f(function(_, snip)
      local class_name = string.gsub(snip.env.TM_FILENAME, ".php", "")

      return "class " .. class_name .. " extends TestCase"
    end, {}),
    t({ "", "{" }),
    t({ "", "    public function setUp(): void", "    {", "        " }),
    i(1),
    t({ "", "    }", "" }),
    t({ "", "    public function it_is_initializable(): void" }),
    t({ "", "    {" }),
    f(function(_, snip)
      local class_under_test = get_class_under_test(snip.env.TM_FILEPATH)

      return { "", "        self::assertInstanceOf('" .. class_under_test .. "');" }
    end, {}),
    t({ "", "    }" }),
    i(0),
    t({ "", "}" }),
  }
)
-- }}}

-- phpspec class {{{
local phpspec_class_snippet = s(
  { trig = "pscla", name = "PhpSpec Class", dscr = "Mike's phpspec class with namespace" },
  {
    t({
      "<?php",
      "",
      "declare(strict_types=1);",
      "",
      "",
    }),
    f(function(_, snip)
      local namespace = get_namespace(snip.env.TM_FILEPATH, snip.env.TM_FILENAME)

      return "namespace " .. namespace .. ";"
    end, {}),
    f(function(_, snip)
      local class_under_test = get_class_under_test(snip.env.TM_FILEPATH)
      return {
        "",
        "",
        "use PhpSpec\\ObjectBehavior;",
        "use Prophecy\\Argument;",
        "use " .. class_under_test .. ";",
        "",
        "/**",
        " * @inheritDoc",
        " *",
        " * ",
      }
    end),
    f(function(_, snip)
      local class_under_test = string.gsub(snip.env.TM_FILENAME, "Spec.php", "")

      return "@see " .. class_under_test
    end, {}),
    t({ "", " */", "" }),
    f(function(_, snip)
      local class_name = string.gsub(snip.env.TM_FILENAME, ".php", "")

      return "final class " .. class_name .. " extends ObjectBehavior"
    end, {}),
    t({ "", "{" }),
    t({ "", "    public function it_is_initializable(): void" }),
    t({ "", "    {" }),
    f(function(_, snip)
      local class_under_test = string.gsub(snip.env.TM_FILENAME, "Spec.php", "")

      return { "", "        $this->shouldHaveType(" .. class_under_test .. "::class);" }
    end, {}),
    t({ "", "    }" }),
    i(0),
    t({ "", "}" }),
  }
)
-- }}}

-- phpspec method {{{
local phpspec_method_snippet = luasnip.parser.parse_snippet(
  { trig = "psmeth", name = "PhpSpec Method" },
  [[

public function it_${1:does_something}($2): void
{
    $3
}]],
  {}
)
-- }}}

local strict_types_snippet = s({ trig = "dst", name = "Strict Types" }, { t({ "", "declare(strict_types=1);" }) })
local inherit_doc_snippet = s({ trig = "id", name = "Inherit Doc" }, { t({ "", "/** @inheritDoc */" }) })
local palette_log_snippet = luasnip.parser.parse_snippet(
  { trig = "plg", name = "Palette Log" },
  '\\Log::debug("$1");',
  {}
)
local legacy_log_snippet = luasnip.parser.parse_snippet(
  { trig = "llg", name = "Legacy Log" },
  '\\Zend_Registry::get("file_logger")->debug("$1");',
  {}
)
local zed_log_snippet = luasnip.parser.parse_snippet(
  { trig = "zlg", name = "Zed Log" },
  '\\PalShared_Log::getLogger()->${1|debug,error,critical,info,warning,notice|}("$2", ${3:[]});',
  {}
)

-- assign {{{
local assign_snippet = s({ trig = "asn", name = "Assign Class Property" }, {
  t("$this->"),
  i(1, "prop"),
  t(" = $"),
  r(1),
  t(";"),
})
-- }}}

-- arg {{{
local argument_snippet = s({ trig = "arg", name = "Function Argument" }, {
  t(""),
  i(1, "MyClass"),
  t(" $"),
  l(l._1:gsub("%a", string.lower, 1), 1),
})
-- }}}

-- var {{{
local class_var_snippet = s({ trig = "va", name = "Class Property" }, {
  c(1, {
    t("private"),
    t("protected"),
    t("public"),
  }),
  t(" "),
  i(2, "MyClass"),
  t(" $"),
  l(l._1:gsub("%a", string.lower, 1), 2),
  t({ ";" }),
})
-- }}}

-- jd {{{
local json_decode_snippet = s({ trig = "json_decode", name = "Json Decode" }, {
  t("\\json_decode("),
  i(1, ""),
  t(", true, 512, \\JSON_THROW_ON_ERROR);"),
})
-- }}}

-- const {{{
local constant_snippet = s({ trig = "cnst", name = "Constant" }, {
  c(1, {
    t("private"),
    t("protected"),
    t("public"),
  }),
  t(" const "),
  i(2, "MY_CONST"),
  t(" = "),
  i(3, "'my value'"),
  t({ ";" }),
})
-- }}}

-- cstr {{{
local constructor_snippet = s({ trig = "cstr", name = "Constructor" }, {
  t({ "", "" }),
  c(1, {
    t("public"),
    t("protected"),
    t("public"),
  }),
  t(" function __construct("),
  t({ "", "" }),
  t("    "),
  i(2, "MyClass"),
  t(" $"),
  l(l._1:gsub("%a", string.lower, 1), 2),
  t({ "", ") {", "" }),
  t("    "),
  t("$this->"),
  l(l._1:gsub("%a", string.lower, 1), 2),
  t(" = $"),
  l(l._1:gsub("%a", string.lower, 1), 2),
  t(";"),
  t({ "", "}" }),
})
-- }}}

-- let {{{
local let_snippet = s({ trig = "let", name = "Phpspec Let" }, {
  t(""),
  t("public function let("),
  t({ "", "" }),
  t("    "),
  i(1, "MyClass"),
  t(" $"),
  l(l._1:gsub("%a", string.lower, 1), 1),
  t({ "", "): void {", "" }),
  t("    "),
  t("$this->beConstructedWith("),
  t({ "", "        $" }),
  l(l._1:gsub("%a", string.lower, 1), 1),
  t({ "", "    );" }),
  t({ "", "}", "" }),
})
-- }}}

-- gtr {{{
local getter_snippet = s({ trig = "gtr", name = "Getter" }, {
  t({ "", "" }),
  c(1, {
    t("public"),
    t("protected"),
    t("public"),
  }),
  t(" function get"),
  i(2, "MyProperty"),
  t("(): "),
  i(3, "string"),
  t({ "", "" }),
  t("    "),
  t("return $this->"),
  l(l._1:gsub("%a", string.lower, 1), 2),
  t(";"),
  t({ "", "}" }),
})
-- }}}

-- str {{{
local setter_snippet = s({ trig = "str", name = "Setter" }, {
  t({ "", "" }),
  c(1, {
    t("public"),
    t("protected"),
    t("public"),
  }),
  t(" function set"),
  i(2, "MyProperty"),
  t("("),
  i(3, "string"),
  t(" $"),
  l(l._1:gsub("%a", string.lower, 1), 2),
  t("): void"),
  t({ "", "{", "" }),
  t("    "),
  t("$this->"),
  l(l._1:gsub("%a", string.lower, 1), 2),
  t(" = $"),
  l(l._1:gsub("%a", string.lower, 1), 2),
  t(";"),
  t({ "", "}" }),
})
-- }}}

-- meth {{{
local method_snippet = s({ trig = "meth", name = "Method" }, {
  t({ "", "" }),
  c(1, {
    t("public"),
    t("protected"),
    t("public"),
  }),
  t(" function "),
  i(2, "myMethod"),
  t("("),
  i(3),
  t("): "),
  i(4, "void"),
  t({ "", "{", "" }),
  t("    "),
  i(5),
  t({ "", "}" }),
})
-- }}}

return {
  -- argument_snippet, moved to php.json
  artisan_snippet,
  -- assign_snippet, moved to php.json
  class_snippet,
  controller_snippet,
  -- class_var_snippet, moved to php.json
  -- constant_snippet, moved to php.json
  constructor_snippet,
  getter_snippet,
  -- inherit_doc_snippet, moved to php.json
  interface_snippet,
  -- json_decode_snippet,
  -- legacy_log_snippet, moved to php.json
  let_snippet,
  -- method_snippet, moved to php.json
  -- palette_log_snippet, moved to php.json
  phpspec_class_snippet,
  -- phpspec_method_snippet, moved to php.json
  phpunit_class_snippet,
  setter_snippet,
  -- strict_types_snippet, moved to php.json
  -- zed_log_snippet, moved to php.json
}

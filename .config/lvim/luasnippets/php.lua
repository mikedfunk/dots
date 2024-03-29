-- vim:set foldmethod=marker:
local luasnip = require 'luasnip'
local snippet = luasnip.snippet
local text_node = luasnip.text_node
local insert_node = luasnip.insert_node
local function_node = luasnip.function_node
local lambda_node = require 'luasnip.extras'.lambda
local choice_node = luasnip.choice_node
local repeat_node = require 'luasnip.extras'.rep

-- helpers {{{
---@param filepath string
---@return string
local function get_class_under_test(filepath)
  local class_under_test = string.gsub(filepath, 'Test.php', '')
  class_under_test = string.gsub(filepath, 'Spec.php', '')
  class_under_test = string.gsub(class_under_test, vim.api.nvim_exec('pwd', true), '')
  class_under_test = string.gsub(class_under_test, '/project/Zed/tests/src/', '')
  class_under_test = string.gsub(class_under_test, '/spec/', 'Palette/')
  class_under_test = string.gsub(class_under_test, '^/(.*)$', '%1')
  class_under_test = string.gsub(class_under_test, '/', '\\')

  return class_under_test
end

---@param filepath string
---@param filename string
---@return string
local function get_namespace(filepath, filename)
  local namespace = string.gsub(filepath, '/' .. filename, '')
  namespace = string.gsub(namespace, vim.api.nvim_exec('pwd', true), '')
  -- TODO: get SUPER fancy with this and use jq to parse composer.json autoload psr-4, then map that to replacing paths
  namespace = string.gsub(namespace, '^/app/(.*)$', 'Palette/%1')
  namespace = string.gsub(namespace, '^/spec/(.*)$', 'spec/Palette/%1')
  namespace = string.gsub(namespace, '/project/Zed/tests', 'Tests')
  namespace = string.gsub(namespace, 'SaatchiArt', 'Palette/SaatchiArt')
  namespace = string.gsub(namespace, '/project/Zed/src/', '')
  namespace = string.gsub(namespace, '^/(.*)$', '%1')
  namespace = string.gsub(namespace, '/', '\\')

  return namespace
end
-- }}}

-- class {{{
local class_snippet = snippet(
  { trig = 'cla', name = 'PHP Class', dscr = "Mike's class with namespace" },
  {
    text_node({
      '<?php',
      '',
      'declare(strict_types=1);',
      '',
      '',
    }),
    function_node(function(_, snip)
      local namespace = get_namespace(snip.env.TM_FILEPATH, snip.env.TM_FILENAME)

      return 'namespace ' .. namespace .. ';'
    end, {}),
    text_node({ '', '', '' }),
    choice_node(1, {
      text_node('final '),
      text_node(''),
    }),
    function_node(function(_, snip)
      local class_name = string.gsub(snip.env.TM_FILENAME, '.php', '')

      return 'class ' .. class_name
    end, {}),
    text_node({ '', '{', '    ' }),
    insert_node(0),
    text_node({ '', '}' }),
  }
)
-- }}}

-- controller {{{
local controller_snippet = snippet(
  { trig = 'cntr', name = 'PHP Class', dscr = "Mike's controller" },
  {
    text_node({
      '<?php',
      '',
      'declare(strict_types=1);',
      '',
      '',
    }),
    function_node(function(_, snip)
      local namespace = get_namespace(snip.env.TM_FILEPATH, snip.env.TM_FILENAME)

      return 'namespace ' .. namespace .. ';'
    end, {}),
    text_node({ '', '', '' }),
    text_node({ 'use Illuminate\\Http\\JsonResponse;', '' }),
    text_node({ 'use Palette\\Http\\Controllers\\Controller;', '' }),
    text_node({ '', '' }),
    function_node(function(_, snip)
      local class_name = string.gsub(snip.env.TM_FILENAME, '.php', '')

      return 'final class ' .. class_name .. ' extends Controller'
    end, {}),
    text_node({ '', '{', '    ' }),
    insert_node(0),
    text_node({ '', '}' }),
  }
)
-- }}}

-- artisan command {{{
local artisan_snippet = snippet(
  { trig = 'art', name = 'Laravel artisan command', dscr = "Laravel artisan command with namespace" },
  {
  text_node({
    '<?php',
    '',
    'declare(strict_types=1);',
    '',
    '',
  }),
  function_node(function(_, snip)
    local namespace = get_namespace(snip.env.TM_FILEPATH, snip.env.TM_FILENAME)

    return 'namespace ' .. namespace .. ';'
  end, {}),
  text_node({ '', '', '' }),
  text_node({ 'use Illuminate\\Console\\Command;' }),
  text_node({ '', '', '' }),
  function_node(function(_, snip)
    local class_name = string.gsub(snip.env.TM_FILENAME, '.php', '')

    return 'class ' .. class_name .. ' extends Command'
  end, {}),
  text_node({ '', '{', '    ' }),
  text_node({ '/** @inheritDoc */', '    protected $signature = \'' }),
  insert_node(1, 'one-timers:do-something'),
  text_node({ ' {--dry-run}\';', '', '' }),
  text_node({ '    /** @inheritDoc */', '    protected $description = \'' }),
  insert_node(2, 'Does something'),
  text_node({ '\';', '', '' }),
  text_node({ '    /** @inheritDoc */', '' }),
  text_node({ '    public function handle()', '    {', '' }),
  text_node({ '        if ($this->option(\'dry-run\')) {', '            $this->info(\'Dry run only, no changes will be made\');', '        }', '', '' }),
  text_node({ '        '}),
  insert_node(3),
  text_node({ '', '    }' }),
  text_node({ '', '}' }),
}
)
-- }}}

-- interface {{{
local interface_snippet = snippet(
  { trig = 'inte', name = 'PHP Interface', dscr = "Mike's interface with namespace" },
  {
  text_node({
    '<?php',
    '',
    'declare(strict_types=1);',
    '',
    '',
  }),
  function_node(function(_, snip)
    local namespace = get_namespace(snip.env.TM_FILEPATH, snip.env.TM_FILENAME)

    return 'namespace ' .. namespace .. ';'
  end, {}),
  text_node({ '', '', '' }),
  function_node(function(_, snip)
    local interface_name = string.gsub(snip.env.TM_FILENAME, '.php', '')

    return 'interface ' .. interface_name
  end, {}),
  text_node({ '', '{', '    ' }),
  insert_node(0),
  text_node({ '', '}' }),
}
)
-- }}}

-- phpunit class {{{
local phpunit_class_snippet = snippet(
  { trig = 'pucla', name = 'PHPUnit Class', dscr = "Mike's phpunit class with namespace" },
  {
  text_node({
    '<?php',
    '',
    'declare(strict_types=1);',
    '',
    '',
  }),
  function_node(function(_, snip)
    local namespace = get_namespace(snip.env.TM_FILEPATH, snip.env.TM_FILENAME)

    return 'namespace ' .. namespace .. ';'
  end, {}),
  function_node(function (_, snip)
    local class_under_test = get_class_under_test(snip.env.TM_FILEPATH)
    return {
      '',
      '',
      'use PHPUnit\\Framework\\TestCase;',
      'use Prophecy\\Argument;',
      'use ' .. class_under_test .. ';',
      '',
      '/**',
      ' * @final',
      ' *',
      ' * ',
    }
  end),
  function_node(function(_, snip)
      local class_under_test = get_class_under_test(snip.env.TM_FILEPATH)

    return '@see ' .. class_under_test
  end, {}),
  text_node({ '', ' */', '' }),
  function_node(function(_, snip)
    local class_name = string.gsub(snip.env.TM_FILENAME, '.php', '')

    return 'class ' .. class_name .. ' extends TestCase'
  end, {}),
  text_node({ '', '{' }),
  text_node({ '', '    public function setUp(): void', '    {', '        ' }),
  insert_node(1),
  text_node({ '', '    }', '' }),
  text_node({ '', '    public function it_is_initializable(): void' }),
  text_node({ '', '    {' }),
  function_node(function(_, snip)
    local class_under_test = get_class_under_test(snip.env.TM_FILEPATH)

    return { '', "        self::assertInstanceOf('" .. class_under_test .. "');" }
  end, {}),
  text_node({ '', '    }' }),
  insert_node(0),
  text_node({ '', '}' }),
}
)
-- }}}

-- phpspec class {{{
local phpspec_class_snippet = snippet(
  { trig = 'pscla', name = 'PhpSpec Class', dscr = "Mike's phpspec class with namespace" },
  {
  text_node({
    '<?php',
    '',
    'declare(strict_types=1);',
    '',
    '',
  }),
  function_node(function(_, snip)
    local namespace = get_namespace(snip.env.TM_FILEPATH, snip.env.TM_FILENAME)

    return 'namespace ' .. namespace .. ';'
  end, {}),
  function_node(function(_, snip)
    local class_under_test = get_class_under_test(snip.env.TM_FILEPATH)
    return {
      '',
      '',
      'use PhpSpec\\ObjectBehavior;',
      'use Prophecy\\Argument;',
      'use ' .. class_under_test .. ';',
      '',
      '/**',
      ' * @inheritDoc',
      ' *',
      ' * ',
    }
  end),
  function_node(function(_, snip)
    local class_under_test = string.gsub(snip.env.TM_FILENAME, 'Spec.php', '')

    return '@see ' .. class_under_test
  end, {}),
  text_node({ '', ' */', '' }),
  function_node(function(_, snip)
    local class_name = string.gsub(snip.env.TM_FILENAME, '.php', '')

    return 'final class ' .. class_name .. ' extends ObjectBehavior'
  end, {}),
  text_node({ '', '{' }),
  text_node({ '', '    public function it_is_initializable(): void' }),
  text_node({ '', '    {' }),
  function_node(function(_, snip)
    local class_under_test = string.gsub(snip.env.TM_FILENAME, 'Spec.php', '')

    return { '', "        $this->shouldHaveType(" .. class_under_test .. "::class);" }
  end, {}),
  text_node({ '', '    }' }),
  insert_node(0),
  text_node({ '', '}' }),
}
)
-- }}}

-- phpspec method {{{
local phpspec_method_snippet = luasnip.parser.parse_snippet(
  { trig = 'psmeth', name = 'PhpSpec Method' },
  [[

public function it_${1:does_something}($2): void
{
    $3
}]],
  {}
)
-- }}}

local strict_types_snippet = snippet({ trig = 'dst', name = 'Strict Types' }, { text_node({ '', 'declare(strict_types=1);' }) })
local inherit_doc_snippet = snippet({ trig = 'id', name = 'Inherit Doc' }, { text_node({ '', '/** @inheritDoc */' }) })
local palette_log_snippet = luasnip.parser.parse_snippet({ trig = 'plg', name = 'Palette Log' }, '\\Log::debug("$1");', {})
local legacy_log_snippet = luasnip.parser.parse_snippet({ trig = 'llg', name = 'Legacy Log' }, '\\Zend_Registry::get("file_logger")->debug("$1");', {})
local zed_log_snippet = luasnip.parser.parse_snippet({ trig = 'zlg', name = 'Zed Log' }, '\\PalShared_Log::getLogger()->${1|debug,error,critical,info,warning,notice|}("$2", ${3:[]});', {})

-- assign {{{
local assign_snippet = snippet({ trig = 'asn', name = 'Assign Class Property' }, {
  text_node('$this->'),
  insert_node(1, 'prop'),
  text_node(' = $'),
  repeat_node(1),
  text_node(';'),
})
-- }}}

-- arg {{{
local argument_snippet = snippet({ trig = 'arg', name = 'Function Argument' }, {
  text_node(''),
  insert_node(1, 'MyClass'),
  text_node(' $'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 1),
})
-- }}}

-- var {{{
local class_var_snippet = snippet({ trig = 'va', name = 'Class Property' }, {
  choice_node(1, {
    text_node('private'),
    text_node('protected'),
    text_node('public'),
  }),
  text_node(' '),
  insert_node(2, 'MyClass'),
  text_node(' $'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 2),
  text_node({ ';' }),
})
-- }}}

-- jd {{{
local json_decode_snippet = snippet({ trig = 'json_decode', name = 'Json Decode' }, {
  text_node("\\json_decode("),
  insert_node(1, ''),
  text_node(", true, 512, \\JSON_THROW_ON_ERROR);"),
})
-- }}}

-- const {{{
local constant_snippet = snippet({ trig = 'cnst', name = 'Constant' }, {
  choice_node(1, {
    text_node('private'),
    text_node('protected'),
    text_node('public'),
  }),
  text_node(' const '),
  insert_node(2, 'MY_CONST'),
  text_node(' = '),
  insert_node(3, "'my value'"),
  text_node({ ';' }),
})
-- }}}

-- cstr {{{
local constructor_snippet = snippet({ trig = 'cstr', name = 'Constructor' }, {
  text_node({ '', '' }),
  choice_node(1, {
    text_node('public'),
    text_node('protected'),
    text_node('public'),
  }),
  text_node(' function __construct('),
  text_node({ '', '' }),
  text_node('    '),
  insert_node(2, 'MyClass'),
  text_node(' $'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 2),
  text_node({ '', ') {', '' }),
  text_node('    '),
  text_node('$this->'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 2),
  text_node(' = $'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 2),
  text_node(';'),
  text_node({ '', '}' }),
})
-- }}}

-- let {{{
local let_snippet = snippet({ trig = 'let', name = 'Phpspec Let' }, {
  text_node(''),
  text_node('public function let('),
  text_node({ '', '' }),
  text_node('    '),
  insert_node(1, 'MyClass'),
  text_node(' $'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 1),
  text_node({ '', '): void {', '' }),
  text_node('    '),
  text_node('$this->beConstructedWith('),
  text_node({ '', '        $' }),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 1),
  text_node({ '', '    );' }),
  text_node({ '', '}', '' }),
})
-- }}}

-- gtr {{{
local getter_snippet = snippet({ trig = 'gtr', name = 'Getter' }, {
  text_node({ '', '' }),
  choice_node(1, {
    text_node('public'),
    text_node('protected'),
    text_node('public'),
  }),
  text_node(' function get'),
  insert_node(2, 'MyProperty'),
  text_node('(): '),
  insert_node(3, 'string'),
  text_node({ '', '' }),
  text_node('    '),
  text_node('return $this->'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 2),
  text_node(';'),
  text_node({ '', '}' }),
})
-- }}}

-- str {{{
local setter_snippet = snippet({ trig = 'str', name = 'Setter' }, {
  text_node({ '', '' }),
  choice_node(1, {
    text_node('public'),
    text_node('protected'),
    text_node('public'),
  }),
  text_node(' function set'),
  insert_node(2, 'MyProperty'),
  text_node('('),
  insert_node(3, 'string'),
  text_node(' $'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 2),
  text_node('): void'),
  text_node({ '', '{', '' }),
  text_node('    '),
  text_node('$this->'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 2),
  text_node(' = $'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 2),
  text_node(';'),
  text_node({ '', '}' }),
})
-- }}}

-- meth {{{
local method_snippet = snippet({ trig = 'meth', name = 'Method' }, {
  text_node({ '', '', }),
  choice_node(1, {
    text_node('public'),
    text_node('protected'),
    text_node('public'),
  }),
  text_node(' function '),
  insert_node(2, 'myMethod'),
  text_node('('),
  insert_node(3),
  text_node('): '),
  insert_node(4, 'void'),
  text_node({ '', '{', '' }),
  text_node('    '),
  insert_node(5),
  text_node({ '', '}' }),
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

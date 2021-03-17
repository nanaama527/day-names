require "./config/environment"

use Rack::MethodOverride

use NameController

use UserController

run ApplicationController

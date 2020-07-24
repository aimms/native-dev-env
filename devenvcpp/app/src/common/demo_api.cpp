#include "example_api.h"
#include <boost/thread.hpp>
#include <iostream>
#include <memory>

namespace demo_api
{

void hello_word()
{
  // for the sake of using boost dynamic libraries
  auto t = std::make_unique<boost::thread>([] { std::cout << "Hello World from boost::thread!" << std::endl; });

  t->join();
}

}// namespace demo_api

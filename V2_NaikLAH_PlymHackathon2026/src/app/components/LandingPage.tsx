import { ArrowRight, Bus, Leaf, Shield, TrendingUp, Award, Users, BarChart3 } from 'lucide-react';
import { ImageWithFallback } from './figma/ImageWithFallback';
import { BarChart, Bar, LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

interface LandingPageProps {
  onStartDemo: () => void;
  onViewEmployer: () => void;
}

export default function LandingPage({ onStartDemo, onViewEmployer }: LandingPageProps) {
  return (
    <div className="min-h-screen bg-white">
      {/* Hero Section - Problem Statement */}
      <section className="relative overflow-hidden bg-gradient-to-br from-pink-50 via-purple-50 to-blue-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
          <div className="text-center mb-16">
            <h1 className="text-5xl font-bold text-gray-900 mb-6">
              Making Sustainable Travel Safe & Rewarding
            </h1>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto mb-8">
              Gamification platform that incentivizes public transport usage with special focus on women's safety
            </p>
            <div className="flex flex-wrap justify-center gap-4">
              <button
                onClick={onStartDemo}
                className="bg-pink-600 text-white px-8 py-4 rounded-lg hover:bg-pink-700 transition-colors flex items-center gap-2 text-lg font-semibold"
              >
                Try Demo <ArrowRight className="w-5 h-5" />
              </button>
              <button
                onClick={onViewEmployer}
                className="bg-white text-gray-900 px-8 py-4 rounded-lg hover:bg-gray-50 transition-colors border-2 border-gray-300 text-lg font-semibold"
              >
                Employer Dashboard
              </button>
            </div>
          </div>

          {/* Problem Visualization */}
          <div className="grid md:grid-cols-2 gap-8 mb-12">
            <div className="relative rounded-2xl overflow-hidden shadow-2xl">
              <ImageWithFallback
                src="https://images.unsplash.com/photo-1602948978286-39d38d379804?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx3b21hbiUyMHdhaXRpbmclMjBidXMlMjBzdG9wJTIwbmlnaHQlMjB3b3JyaWVkfGVufDF8fHx8MTc3MDQ2ODE5Mnww&ixlib=rb-4.1.0&q=80&w=1080"
                alt="Woman waiting at bus stop"
                className="w-full h-80 object-cover"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/70 to-transparent flex items-end">
                <div className="p-6 text-white">
                  <h3 className="text-2xl font-bold mb-2">The Safety Barrier</h3>
                  <p className="text-lg">65% of women avoid public transport due to safety concerns</p>
                </div>
              </div>
            </div>
            <div className="relative rounded-2xl overflow-hidden shadow-2xl">
              <ImageWithFallback
                src="https://images.unsplash.com/photo-1738784046933-151ba8844a0d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx0cmFmZmljJTIwY29uZ2VzdGlvbiUyMGNhcnMlMjBwb2xsdXRpb258ZW58MXx8fHwxNzcwNDY4MTkyfDA&ixlib=rb-4.1.0&q=80&w=1080"
                alt="Traffic congestion"
                className="w-full h-80 object-cover"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/70 to-transparent flex items-end">
                <div className="p-6 text-white">
                  <h3 className="text-2xl font-bold mb-2">The Environmental Cost</h3>
                  <p className="text-lg">70% solo drivers contributing to urban pollution</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* SDG Alignment Section */}
      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-gray-900 mb-4">
              Aligned with UN SDG 11
            </h2>
            <p className="text-xl text-gray-600">Sustainable Cities and Communities</p>
          </div>

          <div className="grid md:grid-cols-3 gap-8">
            <div className="bg-gradient-to-br from-orange-50 to-orange-100 p-8 rounded-2xl shadow-lg">
              <div className="bg-orange-500 w-16 h-16 rounded-full flex items-center justify-center mb-6">
                <Bus className="w-8 h-8 text-white" />
              </div>
              <h3 className="text-2xl font-bold text-gray-900 mb-3">SDG 11.2</h3>
              <h4 className="text-lg font-semibold text-gray-800 mb-2">Affordable & Sustainable Transport</h4>
              <p className="text-gray-700">
                Providing safe, accessible transport for all, with special attention to women, children, and vulnerable groups
              </p>
            </div>

            <div className="bg-gradient-to-br from-green-50 to-green-100 p-8 rounded-2xl shadow-lg">
              <div className="bg-green-500 w-16 h-16 rounded-full flex items-center justify-center mb-6">
                <Leaf className="w-8 h-8 text-white" />
              </div>
              <h3 className="text-2xl font-bold text-gray-900 mb-3">SDG 11.6</h3>
              <h4 className="text-lg font-semibold text-gray-800 mb-2">Reduce Environmental Impact</h4>
              <p className="text-gray-700">
                Reducing per capita environmental impact through improved air quality and sustainable mobility
              </p>
            </div>

            <div className="bg-gradient-to-br from-purple-50 to-purple-100 p-8 rounded-2xl shadow-lg">
              <div className="bg-purple-500 w-16 h-16 rounded-full flex items-center justify-center mb-6">
                <Shield className="w-8 h-8 text-white" />
              </div>
              <h3 className="text-2xl font-bold text-gray-900 mb-3">SDG 11.3</h3>
              <h4 className="text-lg font-semibold text-gray-800 mb-2">Inclusive Urbanization</h4>
              <p className="text-gray-700">
                Enhancing inclusive and sustainable urbanization through participatory and integrated planning
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Key Features */}
      <section className="py-20 bg-gradient-to-br from-gray-50 to-gray-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-gray-900 mb-4">
              How It Works
            </h2>
            <p className="text-xl text-gray-600">Earn rewards for sustainable travel choices</p>
          </div>

          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
            <div className="bg-white p-6 rounded-xl shadow-lg">
              <div className="bg-blue-100 w-14 h-14 rounded-full flex items-center justify-center mb-4">
                <Bus className="w-7 h-7 text-blue-600" />
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-2">Use Public Transport</h3>
              <p className="text-gray-600">Scan QR codes on buses and trains to earn points instantly</p>
            </div>

            <div className="bg-white p-6 rounded-xl shadow-lg">
              <div className="bg-pink-100 w-14 h-14 rounded-full flex items-center justify-center mb-4">
                <Shield className="w-7 h-7 text-pink-600" />
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-2">Women-Only Options</h3>
              <p className="text-gray-600">Access pink buses and women-only cabins for safe travel</p>
            </div>

            <div className="bg-white p-6 rounded-xl shadow-lg">
              <div className="bg-green-100 w-14 h-14 rounded-full flex items-center justify-center mb-4">
                <Award className="w-7 h-7 text-green-600" />
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-2">Earn Rewards</h3>
              <p className="text-gray-600">Redeem points for vouchers, free rides, and exclusive perks</p>
            </div>

            <div className="bg-white p-6 rounded-xl shadow-lg">
              <div className="bg-purple-100 w-14 h-14 rounded-full flex items-center justify-center mb-4">
                <TrendingUp className="w-7 h-7 text-purple-600" />
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-2">Track Impact</h3>
              <p className="text-gray-600">See your CO2 savings and compete on leaderboards</p>
            </div>
          </div>
        </div>
      </section>

      {/* Pink Bus Feature Highlight */}
      <section className="py-20 bg-pink-600 text-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-2 gap-12 items-center">
            <div>
              <h2 className="text-4xl font-bold mb-6">
                Pink Bus: Safety First
              </h2>
              <p className="text-xl mb-6 text-pink-100">
                Dedicated women-only transport removing systemic barriers to sustainable mobility
              </p>
              
              <div className="space-y-4 mb-8">
                <div className="flex items-start gap-3">
                  <Shield className="w-6 h-6 mt-1 flex-shrink-0" />
                  <div>
                    <h4 className="font-semibold text-lg mb-1">Female Drivers & Conductors</h4>
                    <p className="text-pink-100">Trained staff creating a safe environment</p>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <Shield className="w-6 h-6 mt-1 flex-shrink-0" />
                  <div>
                    <h4 className="font-semibold text-lg mb-1">GPS Tracking & Emergency SOS</h4>
                    <p className="text-pink-100">Real-time monitoring with one-tap emergency contact</p>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <Shield className="w-6 h-6 mt-1 flex-shrink-0" />
                  <div>
                    <h4 className="font-semibold text-lg mb-1">CCTV & Safety Ratings</h4>
                    <p className="text-pink-100">Community-verified safe routes and vehicles</p>
                  </div>
                </div>
              </div>

              <div className="bg-white/20 backdrop-blur-sm p-6 rounded-lg border border-white/30">
                <p className="text-lg italic">
                  "I can finally take public transport to my night shift. The pink bus option changed everything for me."
                </p>
                <p className="mt-2 font-semibold">— Lisa, PKT Logistics Employee</p>
              </div>
            </div>
            <div className="relative">
              <div className="rounded-2xl overflow-hidden shadow-2xl">
                <ImageWithFallback
                  src="https://images.unsplash.com/photo-1677128817644-2ace4113ed25?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwaW5rJTIwYnVzJTIwd29tZW4lMjB0cmFuc3BvcnR8ZW58MXx8fHwxNzcwNDY4MTkyfDA&ixlib=rb-4.1.0&q=80&w=1080"
                  alt="Pink bus for women"
                  className="w-full h-96 object-cover"
                />
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Statistics Section */}
      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-gray-900 mb-4">
              The Data Behind Our Mission
            </h2>
            <p className="text-xl text-gray-600">Why women-focused transport matters</p>
          </div>

          <div className="grid md:grid-cols-4 gap-8 mb-12">
            <div className="text-center">
              <div className="text-5xl font-bold text-pink-600 mb-2">65%</div>
              <p className="text-gray-700">Women avoid public transport due to safety concerns</p>
            </div>
            <div className="text-center">
              <div className="text-5xl font-bold text-purple-600 mb-2">83%</div>
              <p className="text-gray-700">Women experience harassment on public transport globally</p>
            </div>
            <div className="text-center">
              <div className="text-5xl font-bold text-blue-600 mb-2">40%</div>
              <p className="text-gray-700">Increase in women's mobility with safe transport options</p>
            </div>
            <div className="text-center">
              <div className="text-5xl font-bold text-green-600 mb-2">70%</div>
              <p className="text-gray-700">Current solo drivers contributing to emissions</p>
            </div>
          </div>

          {/* Data Visualizations */}
          <div className="grid md:grid-cols-2 gap-8 mb-12">
            {/* Women's Safety Statistics Chart */}
            <div className="bg-white border-2 border-gray-200 rounded-2xl p-6 shadow-lg">
              <h3 className="text-xl font-bold text-gray-900 mb-6 flex items-center gap-2">
                <Shield className="w-6 h-6 text-pink-600" />
                Women's Safety Concerns in Public Transport
              </h3>
              <ResponsiveContainer width="100%" height={300}>
                <BarChart data={[
                  { concern: 'Harassment', percentage: 83 },
                  { concern: 'Safety at Night', percentage: 75 },
                  { concern: 'Isolated Areas', percentage: 68 },
                  { concern: 'Lack of CCTV', percentage: 62 },
                  { concern: 'Poor Lighting', percentage: 58 },
                ]}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="concern" angle={-15} textAnchor="end" height={80} />
                  <YAxis label={{ value: '% of Women', angle: -90, position: 'insideLeft' }} />
                  <Tooltip />
                  <Bar dataKey="percentage" fill="#ec4899" name="% Affected" />
                </BarChart>
              </ResponsiveContainer>
              <p className="text-sm text-gray-600 mt-4 italic">
                Source: UN Women Global Study on Urban Safety (2024)
              </p>
            </div>

            {/* Impact of Women-Only Transport */}
            <div className="bg-white border-2 border-gray-200 rounded-2xl p-6 shadow-lg">
              <h3 className="text-xl font-bold text-gray-900 mb-6 flex items-center gap-2">
                <TrendingUp className="w-6 h-6 text-green-600" />
                Impact of Women-Only Transport Options
              </h3>
              <ResponsiveContainer width="100%" height={300}>
                <LineChart data={[
                  { year: '2020', mobility: 42, participation: 28 },
                  { year: '2021', mobility: 58, participation: 41 },
                  { year: '2022', mobility: 71, participation: 54 },
                  { year: '2023', mobility: 82, participation: 68 },
                  { year: '2024', mobility: 94, participation: 79 },
                ]}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="year" />
                  <YAxis label={{ value: 'Index Score', angle: -90, position: 'insideLeft' }} />
                  <Tooltip />
                  <Legend />
                  <Line type="monotone" dataKey="mobility" stroke="#ec4899" strokeWidth={3} name="Women's Mobility" />
                  <Line type="monotone" dataKey="participation" stroke="#8b5cf6" strokeWidth={3} name="Economic Participation" />
                </LineChart>
              </ResponsiveContainer>
              <p className="text-sm text-gray-600 mt-4 italic">
                Cities with Pink Bus initiatives show significant improvements
              </p>
            </div>
          </div>

          {/* Additional Data Points */}
          <div className="bg-gradient-to-br from-pink-50 to-purple-50 rounded-2xl p-8 border-2 border-pink-200">
            <h3 className="text-2xl font-bold text-gray-900 mb-6 text-center">
              Real-World Data: Pink Bus Programs Globally
            </h3>
            <div className="grid md:grid-cols-3 gap-6">
              <div className="bg-white rounded-xl p-6 shadow-md">
                <div className="text-pink-600 font-bold text-sm mb-2">🇮🇳 India (Delhi)</div>
                <div className="text-3xl font-bold text-gray-900 mb-2">+52%</div>
                <p className="text-gray-700 text-sm">Increase in women using public transport after Pink Bus launch</p>
                <p className="text-xs text-gray-500 mt-2">Source: Delhi Transport Authority, 2023</p>
              </div>
              <div className="bg-white rounded-xl p-6 shadow-md">
                <div className="text-purple-600 font-bold text-sm mb-2">🇲🇾 Malaysia (Selangor)</div>
                <div className="text-3xl font-bold text-gray-900 mb-2">67%</div>
                <p className="text-gray-700 text-sm">Women feel safer using dedicated women-only transport</p>
                <p className="text-xs text-gray-500 mt-2">Source: Women's Aid Organisation, 2024</p>
              </div>
              <div className="bg-white rounded-xl p-6 shadow-md">
                <div className="text-blue-600 font-bold text-sm mb-2">🇵🇰 Pakistan (Karachi)</div>
                <div className="text-3xl font-bold text-gray-900 mb-2">-41%</div>
                <p className="text-gray-700 text-sm">Reduction in harassment incidents with women-only transport</p>
                <p className="text-xs text-gray-500 mt-2">Source: Karachi Metropolitan Corp, 2023</p>
              </div>
            </div>
          </div>

          <div className="bg-gray-50 p-8 rounded-2xl mt-8">
            <h3 className="text-2xl font-bold text-gray-900 mb-6 text-center">
              Impact of Women-Only Transport Options
            </h3>
            <div className="grid md:grid-cols-2 gap-8">
              <div>
                <h4 className="font-semibold text-lg mb-3 text-gray-800">Before Pink Bus Initiative</h4>
                <ul className="space-y-2 text-gray-700">
                  <li className="flex items-center gap-2">
                    <div className="w-2 h-2 bg-red-500 rounded-full"></div>
                    Limited mobility for women, especially at night
                  </li>
                  <li className="flex items-center gap-2">
                    <div className="w-2 h-2 bg-red-500 rounded-full"></div>
                    Reduced economic participation and opportunities
                  </li>
                  <li className="flex items-center gap-2">
                    <div className="w-2 h-2 bg-red-500 rounded-full"></div>
                    Higher reliance on private vehicles or expensive taxis
                  </li>
                  <li className="flex items-center gap-2">
                    <div className="w-2 h-2 bg-red-500 rounded-full"></div>
                    Increased urban congestion and emissions
                  </li>
                </ul>
              </div>
              <div>
                <h4 className="font-semibold text-lg mb-3 text-gray-800">With Pink Bus Initiative</h4>
                <ul className="space-y-2 text-gray-700">
                  <li className="flex items-center gap-2">
                    <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                    Safe 24/7 mobility for all women workers
                  </li>
                  <li className="flex items-center gap-2">
                    <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                    Enhanced economic participation and independence
                  </li>
                  <li className="flex items-center gap-2">
                    <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                    Cost-effective sustainable transport option
                  </li>
                  <li className="flex items-center gap-2">
                    <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                    Reduced carbon footprint and traffic congestion
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 bg-gradient-to-br from-purple-600 via-pink-600 to-orange-500 text-white">
        <div className="max-w-4xl mx-auto text-center px-4 sm:px-6 lg:px-8">
          <h2 className="text-4xl font-bold mb-6">
            Ready to Transform Urban Mobility?
          </h2>
          <p className="text-xl mb-8 text-white/90">
            Experience how gamification and safety can drive sustainable behavior change
          </p>
          <div className="flex flex-wrap justify-center gap-4">
            <button
              onClick={onStartDemo}
              className="bg-white text-purple-600 px-8 py-4 rounded-lg hover:bg-gray-100 transition-colors flex items-center gap-2 text-lg font-semibold"
            >
              Start Demo <ArrowRight className="w-5 h-5" />
            </button>
            <button
              onClick={onViewEmployer}
              className="bg-transparent text-white px-8 py-4 rounded-lg hover:bg-white/10 transition-colors border-2 border-white text-lg font-semibold"
            >
              View Employer Dashboard
            </button>
          </div>
        </div>
      </section>
    </div>
  );
}
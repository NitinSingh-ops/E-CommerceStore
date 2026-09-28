import axios from 'axios';

// API base URLs routed through the frontend Nginx reverse proxy
const API_GATEWAYS = {
  user: '/user',
  product: '/product',
  cart: '/cart',
  order: '/order',
};

// Create axios instances for each microservice
const createApiInstance = (baseURL) => {
  const instance = axios.create({
    baseURL,
    timeout: 10000,
  });

  instance.interceptors.request.use(
    (config) => {
      const token = localStorage.getItem('token');
      if (token) {
        config.headers.Authorization = `Bearer ${token}`;
      }
      return config;
    },
    (error) => Promise.reject(error)
  );

  instance.interceptors.response.use(
    (response) => response,
    (error) => {
      if (error.response?.status === 401) {
        localStorage.removeItem('token');
        localStorage.removeItem('user');
        window.location.href = '/login';
      }
      return Promise.reject(error);
    }
  );

  return instance;
};

export const userApi = createApiInstance(API_GATEWAYS.user);
export const productApi = createApiInstance(API_GATEWAYS.product);
export const cartApi = createApiInstance(API_GATEWAYS.cart);
export const orderApi = createApiInstance(API_GATEWAYS.order);

// User Service APIs
export const authService = {
  register: (data) => userApi.post('/api/auth/register', data),
  login: (data) => userApi.post('/api/auth/login', data),
  getProfile: () => userApi.get('/api/auth/me'),
  updateProfile: (data) => userApi.put('/api/users/profile', data),
};

// Product Service APIs
export const productService = {
  getProducts: (params) => productApi.get('/api/products', { params }),
  getProduct: (id) => productApi.get(`/api/products/${id}`),
  getCategories: () => productApi.get('/api/categories'),
  createProduct: (data) => productApi.post('/api/products', data),
  updateProduct: (id, data) => productApi.put(`/api/products/${id}`, data),
  deleteProduct: (id) => productApi.delete(`/api/products/${id}`),
};

// Cart Service APIs
export const cartService = {
  getCart: (userId) => cartApi.get(`/api/cart/${userId}`),
  addToCart: (userId, data) => cartApi.post(`/api/cart/${userId}/items`, data),
  updateCartItem: (userId, productId, data) =>
    cartApi.put(`/api/cart/${userId}/items/${productId}`, data),
  removeFromCart: (userId, productId) =>
    cartApi.delete(`/api/cart/${userId}/items/${productId}`),
  clearCart: (userId) => cartApi.delete(`/api/cart/${userId}`),
  validateCart: (userId) => cartApi.post(`/api/cart/${userId}/validate`),
};

// Order Service APIs
export const orderService = {
  getUserOrders: (userId, params) =>
    orderApi.get(`/api/orders/user/${userId}`, { params }),
  getOrder: (id) => orderApi.get(`/api/orders/${id}`),
  createOrder: (data) => orderApi.post('/api/orders', data),
  updateOrderStatus: (id, data) => orderApi.put(`/api/orders/${id}/status`, data),
  cancelOrder: (id, data) => orderApi.delete(`/api/orders/${id}`, { data }),
  processPayment: (data) => orderApi.post('/api/payments/process', data),
  getPaymentDetails: (orderId) => orderApi.get(`/api/payments/order/${orderId}`),
};

export const handleApiError = (error) => {
  if (error.response) {
    return error.response.data.message || 'An error occurred';
  } else if (error.request) {
    return 'Network error. Please check your connection.';
  } else {
    return 'An unexpected error occurred';
  }
};
